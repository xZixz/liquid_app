require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

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
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      follow_redirect!
      assert_select '.alert.alert-info', 1

      log_in_as user
      assert_not is_logged_in?

      get edit_account_activation_path(user.activation_token, email: user.email)

      follow_redirect!
      assert_not flash.empty?
      assert_template 'users/show'
      assert is_logged_in?
    end
  end
end
