require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "creates a new user" do
    user = attributes_for(:user)

    assert_difference "$user_repository.count", 1 do
      post registrations_path, params: { user: user }
    end

    assert_redirected_to new_session_path
  end

  test "does not create a new user with invalid email" do
    user = attributes_for(:user, email: "invalid_email")

    assert_no_difference "$user_repository.count" do
      post registrations_path, params: { user: user }
    end

    assert_response :unprocessable_entity
  end

  test "does not create a new user with invalid password" do
    user = attributes_for(:user, password: "short")

    assert_no_difference "$user_repository.count" do
      post registrations_path, params: { user: user }
    end

    assert_response :unprocessable_entity
  end

  test "does not create a new user with duplicate email" do
    existing_user = User.create(attributes_for(:user))
    user = attributes_for(:user, email: existing_user.email)

    assert_no_difference "$user_repository.count" do
      post registrations_path, params: { user: user }
    end

    assert_response :unprocessable_entity
  end

  test "does not create a new user with missing password" do
    user = attributes_for(:user, password: nil)

    assert_no_difference "$user_repository.count" do
      post registrations_path, params: { user: user }
    end

    assert_response :unprocessable_entity
  end

  test "does not create a new user with missing email" do
    user = attributes_for(:user, email: nil)

    assert_no_difference "$user_repository.count" do
      post registrations_path, params: { user: user }
    end

    assert_response :unprocessable_entity
  end

  test "redirects to new session when user is authenticated" do
    user_attributes = attributes_for(:user)
    user = User.create(user_attributes)

    post session_path, params: { email: user.email, password: user_attributes[:password] }

    get new_registration_path

    assert_redirected_to home_path
  end
end
