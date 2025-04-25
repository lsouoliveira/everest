Rails.application.config.after_initialize do
  $user_repository = InMemoryUserRepository.new
  User.create({ name: "Test User", email: "test@example.com", password: "123456aa%%AA" })
end

if Rails.env.development?
  ActiveSupport::Reloader.to_prepare do
    $user_repository = InMemoryUserRepository.new
    User.create({ name: "Test User", email: "test@example.com", password: "123456aa%%AA" })
  end
end
