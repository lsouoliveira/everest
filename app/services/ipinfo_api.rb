class IpinfoApi
  class Error < StandardError; end

  Info = Struct.new(:ip, :hostname, :city, :region, :country, :loc, :org, :postal, :timezone, keyword_init: true)

  BASE_URL = "https://ipinfo.io"

  def initialize(token:, adapter: Faraday.default_adapter, stubs: nil)
    @token = token
    @adapter = adapter
    @stubs = stubs
  end

  def fetch_info(ip)
    response = connection.get("/#{ip}/json", { token: @token })

    parse_data(response.body)
  rescue Faraday::Error => e
    raise Error, "Failed to fetch IP info: #{e.message}"
  end

  def self.with_defaults
    new(token: ENV.fetch("IPINFO_TOKEN"))
  end

  private
  def connection
    @_connection ||= Faraday.new(url: BASE_URL) do |conn|
      conn.request :json

      conn.response :json, content_type: "application/json"
      conn.response :raise_error

      conn.adapter @adapter, @stubs
    end
  end

  def parse_data(data)
    Info.new(
      ip: data["ip"],
      hostname: data["hostname"],
      city: data["city"],
      region: data["region"],
      country: data["country"],
      loc: data["loc"],
      org: data["org"],
      postal: data["postal"],
      timezone: data["timezone"]
    )
  end
end
