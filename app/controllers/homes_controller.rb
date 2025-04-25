class HomesController < DashboardController
  def show
    @ipinfo = Rails.cache.fetch("ipinfo/#{request.remote_ip}", expires_in: 1.hour, skip_nil: true) do
      IpinfoApi.with_defaults.fetch_info(request.remote_ip)
    end
  rescue IpinfoApi::Error => e
    Rails.logger.error "Failed to fetch IP info: #{e.message}"
  end
end
