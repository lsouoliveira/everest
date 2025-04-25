class InMemoryUserRepository < UserRepository
  def initialize(users = {})
    @users = users
  end

  def save(user)
    @users[user.id] = user
  end

  def find_by_id(id)
    user = @users[id]
    raise NotFound, "User with id #{id} not found" unless user

    user
  end

  def find_by_email(email)
    user = @users.values.find { |u| u.email == email }
    raise NotFound, "User with email #{email} not found" unless user

    user
  end

  def find_first_by_order_by_created_at_desc
    @users.values.max_by(&:created_at)
  end

  def count
    @users.size
  end

  def clear
    @users.clear
  end
end
