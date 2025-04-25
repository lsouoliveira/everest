Rails.application.config.after_initialize do
  $user_repository = InMemoryUserRepository.new
end

if Rails.env.development?
  ActiveSupport::Reloader.to_prepare do
    $user_repository = InMemoryUserRepository.new
  end
end
