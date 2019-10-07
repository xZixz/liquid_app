require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: '', password: '123', password_confirmation: '123', email: 'kien'
      } }
    end
    assert_template 'users/new'
    assert_select '#error_explanation div ul li', 3
  end

  test 'valid signup' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'shawn', password: '123456',
        password_confirmation: '123456', email: 'valid@va.lid'
      } }
      follow_redirect!
      assert_template 'users/show'
      assert_not flash.empty?
      assert_select '.alert.alert-success', 1
      assert is_logged_in?
    end
  end
end
