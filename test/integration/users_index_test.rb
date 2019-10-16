require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:me)
    @another_one = users(:thanh)
  end

  test 'index got paginated' do
    log_in_as @user
    get users_path

    assert_select '.pagination'
    assert_select 'ul.users li', 30
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @user
        assert_select 'a[href=?]', user_path(user), text: 'Delete'
      end
    end
  end

  test 'not admin, do not view delete link' do
    log_in_as @another_one
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end
end
