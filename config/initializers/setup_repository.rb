Rails.application.config.after_initialize do
  $user_repository = InMemoryUserRepository.new
end
