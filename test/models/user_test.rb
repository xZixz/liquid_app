# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'shawn', email: 'shawn@k.com',
                     password: '123456', password_confirmation: '123456')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '   '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test "name's length should not over 51 chars" do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test "email's length should not over 255 chars" do
    @user.email = 'a' * 250 + '@k.com'
    assert_not @user.valid?
  end

  test 'some valid emails' do
    valid_emails = %w[user@email.com USER@foo.COM a_us-ER@foo.bar.org alice+pop@mail.com]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test 'some invalid emails' do
    invalid_emails = %w[user@example,com user_at_foo.org user.name@example. foo@bar+baz.com foo@bar..com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test 'email should be unique' do
    @user.save
    dup_user = @user.dup
    assert_not dup_user.valid?
  end

  test 'email should be case insensitive unique' do
    @user.save
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    assert_not dup_user.valid?
  end

  test 'email should be lowercase after save' do
    @user.email = 'AbC@e.com'
    @user.save
    assert_equal 'abc@e.com', @user.reload.email
  end

  test 'password must be longer than 6' do
    @user.password = @user.password_confirmation = '1' * 5
    assert_not @user.valid?
  end

  test 'authenticated with nill remember_token should return false' do
    assert_not @user.authenticated? :remember, nil
  end
end
