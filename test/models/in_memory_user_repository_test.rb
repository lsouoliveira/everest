require "test_helper"

class InMemoryUserRepositoryTest < ActiveSupport::TestCase
  test "returns the user count" do
    users = {
      "local-part@domain" => build(:user, email: "local-part@domain")
    }

    user_repository = InMemoryUserRepository.new(users)

    assert_equal 1, user_repository.count
  end

  test "saves a user" do
    user = build(:user)

    user_repository = InMemoryUserRepository.new

    assert_difference -> { user_repository.count }, 1 do
      user_repository.save(user)
    end
  end

  test "finds a user by email" do
    user = build(:user, email: "local-part@domain")
    users = { user.email => user }

    user_repository = InMemoryUserRepository.new(users)

    found_user = user_repository.find_by_email(user.email)

    assert_equal user, found_user
  end

  test "raises an error when user not found" do
    user = build(:user, email: "local-part@domain")
    users = { user.email => user }

    user_repository = InMemoryUserRepository.new(users)

    assert_raises(InMemoryUserRepository::NotFound) do
      user_repository.find_by_email("invalid email")
    end
  end

  test "finds the first user ordered by created_at desc" do
    user1 = build(:user, created_at: 2.days.ago)
    user2 = build(:user, created_at: 1.day.ago)
    users = { user1.email => user1, user2.email => user2 }

    user_repository = InMemoryUserRepository.new(users)

    last_user = user_repository.find_first_by_order_by_created_at_desc

    assert_equal user2, last_user
  end
end
