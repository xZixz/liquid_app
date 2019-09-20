require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home too" do
    get root_path
    assert_response :success
    assert_select "title", "Liquid"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Liquid"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | Liquid"
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Liquid"
  end
end
