require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: " ", email: "user@invalid", password: "hello", password_confirmation: "hai"}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'form[action="/signup"]'
  end
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count',1 do 
      post users_path, params: {user: {name: "Sandhya janu", email: "user@example.com", password: "user123", password_confirmation: "user123"}}
    end
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
