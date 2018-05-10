require 'json'
require 'base64'
require 'open-uri'
require 'net/http'

# Global Variables
# Can be omitted to only scrape public instagram users' data
ADMIN_USERNAME = nil
ADMIN_PASSWORD = nil

# Can be obtained from https://cloud.google.com/vision/docs/auth
GOOGLE_API_KEY = nil

class User < ApplicationRecord
  # Validations
  validates_presence_of :instagram
  validates_format_of :instagram, with: /\A[\w]([^@\s,;]+)\z/, message: 'must be a valid instagram username'
  validate :instagram_username_exists

  def wordsApi(word)
    # These code snippets use an open-source library. http://unirest.io/ruby
    response = Unirest.get "https://wordsapiv1.p.mashape.com/words/#{word}",
                           headers: {
                               "X-Mashape-Key" => "aCQ9RH7mGdmshynPiF4aJRrctMc6p1gtXAajsnkxgtKggNFqHV",
                               "X-Mashape-Host" => "wordsapiv1.p.mashape.com"
                           }
    puts response.raw_body
  end

  def scrape
    # Uses instagram-scraper from https://github.com/rarcega/instagram-scraper to download images

    # Scrape from private users followed by admin
    # system "instagram-scraper #{self.instagram} -d ./images/instagram/#{self.instagram} -u #{ADMIN_USERNAME} -p #{ADMIN_PASSWORD} -m 5"

    # Scrape public users
    system "instagram-scraper #{self.instagram} -d ./images/instagram/#{self.instagram}"
  end

  def analyze
    # Uses Google Cloud Vision API from https://cloud.google.com/vision/ to create a json files with labels from each image
    Dir.foreach("./images/instagram/#{self.instagram}") do |item|
      next if item == '.' or item == '..'

      # Reads and base64 encodes relevant files/images to be sent to the API
      image = open("./images/instagram/#{self.instagram}/#{item}") {|f| f.read}
      rqs = [{"image": {"content": Base64.strict_encode64(image)}, "features": [{"type": "LABEL_DETECTION"}]}]
      rq = {}
      rq["requests"] = rqs
      # Writes the appropriate request in json format
      File.open("./requests/instagram_#{self.instagram}.json", "w") {|f| f.write("#{rq.to_json}")}
      # Calls a helper to send json request and compile json responses
      self.get_labels
    end
  end

  def get_labels
    # Uses Google Cloud Vision API from https://cloud.google.com/vision/
    # Sends json requests to API and compiles responses into json
    system "curl -v -a -H \"Content-Type: application/json\" \
      https://vision.googleapis.com/v1/images:annotate?key=#{GOOGLE_API_KEY} \
      --data-binary @requests/instagram_#{self.instagram}.json >> \"labels/instagram_#{self.instagram}.json\""
  end

  def interpret
    # Creates a text file with the user's labels listed in descending order of frequency from the compiled json
    system "python3 -c 'from label_helper import *; json_to_txt(\"#{self.instagram}\")'"
  end

  private

  def instagram_username_exists
    # Check that the instagram username is valid
    begin
      open("https://www.instagram.com/#{self.instagram}/")
    rescue
      errors.add(:instagram, 'Must enter a valid instagram username.')
    end
  end
end
