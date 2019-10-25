require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:thanh)
  end
  test 'account_activation' do
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation @user
    assert_equal 'Account activation', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end

end
