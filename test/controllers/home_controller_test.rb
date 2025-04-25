require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    get home_url
    assert_response :success
  end
end
