require "test_helper"

class IpinfoApiTest < ActiveSupport::TestCase
  test "fetchs the ip info" do
    json =<<~JSON
    {
      "ip": "54.246.228.58",
      "hostname": "ec2-54-246-228-58.eu-west-1.compute.amazonaws.com",
      "city": "Dublin",
      "region": "Leinster",
      "country": "IE",
      "loc": "53.3331,-6.2489",
      "org": "AS16509 Amazon.com, Inc.",
      "postal": "D02",
      "timezone": "Europe/Dublin"
    }
    JSON

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/54.246.228.58/json?token=test") do
        [ 200, { "Content-Type" => "application/json" }, json ]
      end
    end

    client = IpinfoApi.new(token: "test", adapter: :test, stubs:)
    info = client.fetch_info("54.246.228.58")

    assert_equal info.ip, "54.246.228.58"
    assert_equal info.hostname, "ec2-54-246-228-58.eu-west-1.compute.amazonaws.com"
    assert_equal info.city, "Dublin"
    assert_equal info.region, "Leinster"
    assert_equal info.country, "IE"
    assert_equal info.loc, "53.3331,-6.2489"
    assert_equal info.org, "AS16509 Amazon.com, Inc."
    assert_equal info.postal, "D02"
    assert_equal info.timezone, "Europe/Dublin"
  end

  test "raises error when request fails" do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/54.246.228.58/json?token=test") do
        [ 500, { "Content-Type" => "application/json" }, {}.to_json ]
      end
    end

    client = IpinfoApi.new(token: "test", adapter: :test, stubs:)

    assert_raises(IpinfoApi::Error) do
      client.fetch_info("54.246.228.58")
    end
  end
end
