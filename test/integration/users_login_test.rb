require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:me)
  end

  test 'flash not appear after go to homepage' do
    get login_path
    assert_select 'h1', 'Log In'
    assert_select 'label', 'Email'
    assert_select 'label', 'Password'

    post login_path, params: {
      session: { email: 'taolao', password: 'taolao' }
    }
    assert_select 'h1', 'Log In'
    assert_select 'label', 'Email'
    assert_select 'label', 'Password'
    assert_select '.alert.alert-danger', 1

    assert_not flash.empty?

    get root_path
    assert flash.empty?
  end

  test 'login with valid information' do
    get login_path
    post login_path params: {
      session: { email: @user.email, password: '123456' }
    }
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a[href=?]', login_path, 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    assert is_logged_in?
  end

  test 'login with valid information then log out' do
    get login_path
    post login_path params: {
      session: { email: @user.email, password: '123456' }
    }
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a[href=?]', login_path, 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    assert is_logged_in?

    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, 0
    assert_select 'a[href=?]', user_path(@user), 0
    assert_not is_logged_in?

  end
end
