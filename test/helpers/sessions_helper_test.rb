require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:me)
    remember(@user)
  end

  test 'current user valid with correct remember token' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current user invalid with wrong remember token' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
