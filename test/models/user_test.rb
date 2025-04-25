require "test_helper"

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_least(5).is_at_most(128)

  should validate_presence_of(:password)
  should validate_length_of(:password).is_at_least(10).is_at_most(72)

  test "creates a user with valid attributes" do
    attributes = {
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    }

    user = User.create(attributes)
    last_user = $user_repository.find_first_by_order_by_created_at_desc

    assert_equal user, last_user
  end

  test "does not create a user with invalid attributes" do
    attributes = {
      name: "John Doe",
      email: "invalid email",
      password: "1234"
    }

    user = User.create(attributes)

    assert_not user.valid?
  end

  test "validates user password has at least two digits" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.password = "password%%Azz"
    assert_not user.valid?
  end

  test "validates user password has at least two special characters" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.password = "password12AAzz"
    assert_not user.valid?
  end

  test "validates user password is valid for all possible special characters" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain"
    )

    PasswordValidator::SPECIAL_CHARACTERS.split.each do |char|
      user.password = "password12AAzz#{char}"

      assert user.valid?
    end
  end

  test "validates user password has at least two uppercase letter" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.password = "password12%%azz"
    assert_not user.valid?
  end

  test "validates user password has at least two lowercase letter" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.password = "password12%%aazz"
    assert_not user.valid?
  end

  test "validates email local part has at maximum 64 characters" do
    user = User.new(
      name: "John Doe",
      email: "#{"a" * 64}@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.email = "a" * 65 + "@domain"
    assert_not user.valid?
  end

  test "validates email local part has at least 1 character" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.email = "@domain"
    assert_not user.valid?
  end

  test "validates email domain has at maximum 128 characters" do
    user = User.new(
      name: "John Doe",
      email: "local-part@#{"a" * 128}",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.email = "local-part@#{"a" * 129}"

    assert_not user.valid?
  end

  test "validates email domain has at least 1 character" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.email = "local-part@"
    assert_not user.valid?
  end

  test "validates email domain has only numbers, letters, dots and dashes" do
    user = User.new(
      name: "John Doe",
      email: "local-part@domain",
      password: "password12%%AAzz"
    )

    assert user.valid?

    user.email = "_"
  end

  test "validates email is unique" do
    user = User.create(attributes_for(:user, email: "local-part@domain"))
    user2 = User.new(attributes_for(:user, email: user.email))

    assert user.valid?
    assert_not user2.valid?
  end

  test "authenticate_by returns user when credentials are valid" do
    user = User.create(attributes_for(:user, email: "local-part@domain", password: "password12%%AAzz"))

    authenticated_user = User.authenticate_by(email: user.email, password: user.password)

    assert_equal user, authenticated_user
  end

  test "authenticate_by returns nil when credentials are invalid" do
    user = User.create(attributes_for(:user, email: "local-part@domain", password: "password12%%AAzz"))

    authenticated_user = User.authenticate_by(email: user.email, password: "wrong_password")

    assert_nil authenticated_user
  end

  test "authenticate_by returns nil when user is not found" do
    authenticated_user = User.authenticate_by(email: "non_existent_user@domain", password: "password12%%AAzz")

    assert_nil authenticated_user
  end
end
