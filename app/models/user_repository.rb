class UserRepository
  class Error < StandardError; end
  class NotFound < Error; end

  def save(user)
    raise NotImplementedError
  end

  def find_by_email(email)
    raise NotImplementedError
  end

  def find_first_by_order_by_created_at_desc
    raise NotImplementedError
  end

  def count
    raise NotImplementedError
  end
end
