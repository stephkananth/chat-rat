require 'test_helper'

class UserTest < ActiveSupport::TestCase
  << << << < HEAD
  # test "the truth" do
  #   assert true
  # end

  test "api call for words" do
    puts User.wordsApi("Sky")
  end
  === === =
      >> >> >> > 6664 f29f444f6aeb2c06fc1ecfb709ccacd39069
end
