class InMemoryUserRepository < UserRepository
  def initialize(users = {})
    @users = users
  end

  def save(user)
    @users[user.email] = user
  end

  def find_by_email(email)
    user = @users[email]
    raise NotFound, "User with email #{email} not found" unless user

    user
  end

  def find_first_by_order_by_created_at_desc
    @users.values.max_by(&:created_at)
  end

  def count
    @users.size
  end
end
