require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :me
    @another_one = users :thanh
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'redirect to login if not logged in yet' do
    get edit_user_path(@user)
    assert_not_nil flash[:danger]
    assert_redirected_to login_path

    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert_not_nil flash[:danger]
    assert_redirected_to login_path
  end

  test 'redirect back to where user want to end up when not authenticated' do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_path @user
    log_in_as @user
    assert_redirected_to @user
  end

  test 'redirect to root url if user do not have authorization' do
    log_in_as @another_one, password: 'qwerty'
    get edit_user_path @user
    assert_redirected_to root_url

    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    } }
    assert_redirected_to root_url
  end

  test 'redirect to login page when unauthenticated user access to index' do
    get users_path
    assert_redirected_to login_path
  end

  test 'submit update admin not able by web' do
    log_in_as @another_one, password: 'qwerty'
    assert_not @another_one.admin?
    patch user_path(@another_one), params: { user: {
      password: '123456', password_confirmation: '123456', admin: true
    } }
    assert_not @another_one.admin?
  end

  test 'should redirect to homepage if destroy user without admin privilege' do
    log_in_as @another_one, password: 'qwerty'
    assert_not @another_one.admin?
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  test 'should redirect to login when destroy without login' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test 'should redirect to root when account is not activated' do
    log_in_as @user
    not_activated_user = users(:not_activated)
    get user_path(not_activated_user)
    assert_redirected_to root_path
  end

  test 'successfully destroy user' do
    log_in_as @user
    assert_difference 'User.count', -1 do
      delete user_path(@another_one)
    end
  end

  test 'should redirect if not logged in when access following' do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test 'should redirect if not logged in when access followers' do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end
