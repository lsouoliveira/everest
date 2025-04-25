require "test_helper"

class HomesControllerTest < ActionDispatch::IntegrationTest
  test "returns a success response when user is logged in" do
    ipinfo = IpinfoApi::Info.new(
      ip: "127.0.0.1",
      hostname: "localhost",
      city: "City",
      region: "Region",
      country: "Country",
      loc: "Location",
      org: "Organization",
      postal: "Postal",
      timezone: "Timezone"
    )
    mock = Minitest::Mock.new
    mock.expect :fetch_info, ipinfo, [ "127.0.0.1" ]

    user_attributes = attributes_for(:user)
    user = User.create(user_attributes)

    post session_path, params: { email: user.email, password: user_attributes[:password] }

    IpinfoApi.stub :with_defaults, mock do
      get home_url
    end

    assert_response :success
  end

  test "returns a success response when api fails" do
    IpinfoApi.stub :with_defaults, -> { raise IpinfoApi::Error.new("API error") } do
      user_attributes = attributes_for(:user)
      user = User.create(user_attributes)

      post session_path, params: { email: user.email, password: user_attributes[:password] }

      get home_url

      assert_response :success
    end
  end
end
