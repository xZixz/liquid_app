require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:me)
  end

  test 'password reset' do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Invalid email
    post password_resets_path(password_reset: { email: 'invalid@email.com' })
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path(password_reset: { email: @user.email })
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    @user = assigns(:user)

    # Wrong email
    get edit_password_reset_path(@user.reset_token, email: 'taolao@email.com')
    assert_redirected_to root_path

    # Right email, wrong token
    get edit_password_reset_path('taolao token', email: @user.email)
    assert_redirected_to root_path

    # Right email, not activated
    @user.update_attribute(:activated, false)
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_redirected_to root_path

    # Right email
    @user.update_attribute(:activated, true)
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', @user.email

    # Reset password
    patch password_reset_path(params: {
                                user: {
                                  password: '1234567',
                                  password_confirmation: '1234567'
                                },
                                email: @user.email
                              })
    assert_not_equal @user.password_digest, @user.reload.password_digest
    assert_nil @user.reload.reset_digest
    assert is_logged_in?
    assert_redirected_to @user

  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path(params: {
                                password_reset: {
                                  email: @user.email
                                }
                              })
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token, params: {
                                email: @user.email,
                                user: {
                                  password: '1234567',
                                  password_confirmation: '1234567'
                                }
                              })
    assert_response :redirect
    follow_redirect!
    assert_match(/expired/i, response.body)
  end
end
