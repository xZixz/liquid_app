require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:me)
  end

  test 'micropost interface' do
    log_in_as @user
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # Invalid post submission
    assert_no_difference 'Micropost.count' do
      post microposts_path params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = 'This is a friendly comment'
    picture = fixture_file_upload('rubick.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    @micropost = assigns(:micropost)
    assert @micropost.picture?
    assert_redirected_to root_path
    assert !flash.empty?
    follow_redirect!
    assert_match content, response.body

    # Delete a post
    assert_select 'a', 'delete'
    first_post = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_post)
    end
    assert !flash.empty?

    # Visit other user's profile
    get user_path(users(:thanh))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar' do
    log_in_as @user
    get root_path
    assert_match '33 microposts', response.body

    log_in_as users(:thanh), password: 'qwerty'
    get root_path
    assert_match '1 micropost', response.body

    log_in_as users(:user_1)
    get root_path
    assert_match '0 microposts', response.body
  end
end
