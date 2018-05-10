# ChatRat

## What It Does
ChatRat is a program that takes a user's instagram username and has a conversation with him or her based on the information it scraped from their instagram profile.

## How It Does It

### 1. Scrapes Instagram
The program uses [instagram-scraper](https://github.com/rarcega/instagram-scraper), which is a command-line application written in Python that scrapes and downloads an instagram user's photos and videos. If the user's instagram is a public account, the only input necessary is his or her username. However, if the user's instagram is a private account, his or her data can still be accessed by entering the instagram credentials of the user or an account that follows the user. This can be done in lines 8-9 of ChatRat/app/models/user.rb. ChatRat uses 'system' to call the application (instagram-scraper) using the command-line through Ruby on Rails. The user's images are downloaded to an images directory within ChatRat (`ChatRat/images`).

### 2. Analyzes Images
The program uses the [Google Cloud Vision API](https://cloud.google.com/vision/) for image content analysis.

#### a. Formats Request
The program must format a JSON request for each image in order to send it to the API for its content to be analyzed. The API requires that the request includes the image as a base64-encoded string and the feature type(s) desired in the output. The feature that ChatRat uses is 'LABEL DETECTION' to get labels for the content of each image. ChatRat organizes the response into a hashmap then formats it into the corresponding json.

#### b. Sends Request & Recieves Output
The program makes an API call using system and curl to send the json request and recieve the json response from the Google Cloud Vision API. The response is saved in `ChatRat/labels`.

#### c. Formats Output
The response is recieved as json, which is then formatted into a text file as a list of labels ordered by frequency in descending order; thus, the most common labels for instagram images are at the top of the list. This is done by calling a python script using system. The script takes the json responses recived from the API and compiles this orderly list. The python script is located at `ChatRat/label_helper.py`. The text file where the labels are listed is located in `ChatRat/labels`.

### 3. Interprets Output
Because the output is ordered by frequency, the most commonly found labels are at the top of the file; thus, the labels at the top are the most relevant and important, and the ChatBot should give preference to them. We would like to run ChatRat on many public instagram profiles and build a list of common objects. Using this list we want to filter out common objects to present the user of the Chat with a more unique and taylored experience. We hope to use a natural language processing engine or syntax processing to analyze the labels holistically to group objects by type or category.

### 4. Talks to User
Using the categories, we want the Chatbot to enlist premade responses and pass in the specific object in question. As of now, we recommend extending the Google Assistant and/or Dialog flow to create the conversation. The goal of the chat is designed to tell the user the detail and extent of information we have found from their profile. 

### 5. Interface
The interface uses Ruby on Rails scaffolding and imports the CSS Framework [Bulma.io](https://bulma.io) in the `app/assets/stylesheets/application.scss` file.The design features a textbox in which the user imputs their instagram handle. The instagram handle is verified as active and does not require the "@" symbol. The home page is styled in the individual file `app/assets/stylesheets/application.scss`.

### 6. Ties It All Together
ChatRat uses Ruby on Rails to combine all the separate pieces into one program that can be hosted on the web. It uses Ruby-2.4.2 and Rails-5.4.1. The flexibility of Ruby on Rails allows for the program to integrate all the various components, including the user interface.

## How to Run It
1. Ensure all dependencies are installed.
2. Clone the repository.
3. Open `ChatRat/app/models/user.rb` and enter a Google Cloud Vision API Key in line 12.
4. Execute the Following Commands:
   `cd ChatRat`
   `bundle install`
   `rails db:migrate`
   `rails server`.
5. Open browser and navigate to `localhost:3000`.
