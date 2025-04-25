require "test_helper"

class InMemoryUserRepositoryTest < ActiveSupport::TestCase
  test "returns the user count" do
    users = {
      "1234" => build(:user, id: "1234", email: "local-part@domain")
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

  test "finds a user by id" do
    user = build(:user, id: "1234", email: "local-part@domain")
    users = { "1234" => user }

    user_repository = InMemoryUserRepository.new(users)

    found_user = user_repository.find_by_id(user.id)

    assert_equal user, found_user
  end

  test "finds a user by email" do
    user = build(:user, id: "1234", email: "local-part@domain")
    users = { "1234" => user }

    user_repository = InMemoryUserRepository.new(users)

    found_user = user_repository.find_by_email(user.email)

    assert_equal user, found_user
  end

  test "raises an error when user not found" do
    user = build(:user, id: "1234", email: "local-part@domain")
    users = { "1234" => user }

    user_repository = InMemoryUserRepository.new(users)

    assert_raises(InMemoryUserRepository::NotFound) do
      user_repository.find_by_email("invalid email")
    end
  end

  test "finds the first user ordered by created_at desc" do
    user1 = build(:user, id: "1234", created_at: 2.days.ago)
    user2 = build(:user, id: "12345", created_at: 1.day.ago)
    users = { "1234" => user1, "12345" => user2 }

    user_repository = InMemoryUserRepository.new(users)

    last_user = user_repository.find_first_by_order_by_created_at_desc

    assert_equal user2, last_user
  end

  test "clears all users" do
    user1 = build(:user, id: "1234", email: "local-part@domain")
    user2 = build(:user, id: "12345", email: "local-part2@domain")
    users = { "1234" => user1, "12345" => user2 }
    user_repository = InMemoryUserRepository.new(users)
    assert_equal 2, user_repository.count
    user_repository.clear
    assert_equal 0, user_repository.count
  end
end
