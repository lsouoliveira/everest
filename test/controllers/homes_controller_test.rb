require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    get home_url
    assert_response :success
  end
end
