require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:cat)
  end
  test 'should redirect to login path if not logged in yet' do
    assert_no_difference 'Micropost.count' do
      post microposts_path params: { micropost: { content: 'What' } }
    end
    assert_redirected_to login_path
  end

  test 'should redirect to login path if delete but not logged in yet' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_path
  end

  test 'should redirect to root if destroy wrong micropost' do
    log_in_as users(:me)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(microposts(:thanh_post))
    end
    assert_redirected_to root_path
  end
end
