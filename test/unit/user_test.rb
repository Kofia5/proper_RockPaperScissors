require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "create empty user" do
    assert User.new
  end

  test "cannot save user w/only username" do
    badUser = User.create(:username => 'bad')
    assert !badUser.save
  end

  test "create good user" do
    assert users(:one)
  end

  test "short password" do
    assert !users(:bad_pass).save
  end

  test "easy user create" do
    easy_user = User.create(:email => 'fqwer@vad.com', :username => 'easy', 
                            :password => 'qwerty', 
                            :password_confirmation => 'qwerty')
    assert easy_user.save
  end

  
end
