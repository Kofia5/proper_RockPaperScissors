require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test "should get setup" do
    get :setup
    assert_response :success
  end

  test "should get play" do
    get :play
    assert_response :success
  end

end
