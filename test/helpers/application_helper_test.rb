require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'Liquid'
    assert_equal full_title('Contact'), 'Contact | Liquid'
  end
end
