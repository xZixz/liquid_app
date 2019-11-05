require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:me)
    log_in_as @user
    @other_guy = users(:user_7)
  end

  test 'following page' do
    get following_user_path @user
    assert_match 'Following', response.body
    assert_match @user.following.count.to_s, response.body
    assert_not @user.following.empty?
    @user.following.each do |fol|
      assert_select 'a[href=?]', user_path(fol)
    end
  end

  test 'followers page' do
    get followers_user_path @user
    assert_match 'Followers', response.body
    assert_match @user.followers.count.to_s, response.body
    assert_not @user.followers.empty?
    @user.followers.each do |fol|
      assert_select 'a[href=?]', user_path(fol)
    end
  end

  test 'follow html' do
    assert_difference '@user.following.count', 1 do
      post relationships_path params: { followed_id: @other_guy.id }
    end
  end

  test 'follow ajax' do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_guy.id }, xhr: true
    end
  end

  test 'unfollow ajax' do
    assert_difference '@user.following.count', -1 do
      relationship = relationships(:one)
      delete relationship_path(relationship), xhr: true
    end
  end

  test 'unfollow html' do
    assert_difference '@user.following.count', -1 do
      relationship = relationships(:one)
      delete relationship_path(relationship)
    end
  end

  test 'feed on home page' do
    get root_path
    @user.feed.paginate(page: 1).each do |fe|
      assert_match CGI.escapeHTML(fe.content), response.body
    end
  end
end
