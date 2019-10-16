require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:me)
  end

  test 'render edit when udating fails' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: 'invalid email',
      password: '',
      password_confirmation: ''
    } }
    assert_template 'users/edit'
    assert_select '.alert'
  end

  test 'successful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    new_name = 'new name'
    new_email = 'valid@email.com'
    patch user_path(@user), params: { user: {
      name: new_name,
      email: new_email,
      password_confirmation: '',
      password: ''
    } }
    assert_not_nil flash[:success]
    assert_redirected_to @user
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end
end
