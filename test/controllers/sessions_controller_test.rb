require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_session_path
    assert_response :success
  end

  test "creates a new session" do
    user_attributes = attributes_for(:user)
    user = User.create(user_attributes)

    post session_path, params: { email: user.email, password: user_attributes[:password] }

    assert_redirected_to root_path
  end

  test "redirects to new session when authentication fails" do
    post session_path, params: { email: "local-part@domain", password: "password12%%AAzz" }

    assert_redirected_to new_session_path
  end

  test "redirects to new session when user is not authenticated" do
    get home_path

    assert_redirected_to new_session_path
  end

  test "redirects to the original URL after authentication" do
    User.create(attributes_for(:user))

    get home_path

    assert_redirected_to new_session_path
  end

  test "redirects to the home page when user is authenticated" do
    user_attributes = attributes_for(:user)
    user = User.create(user_attributes)

    post session_path, params: { email: user.email, password: user_attributes[:password] }

    get root_url

    assert_redirected_to home_path
  end

  test "destroy" do
    user_attributes = attributes_for(:user)
    user = User.create(user_attributes)

    post session_path, params: { email: user.email, password: user_attributes[:password] }

    delete session_path

    assert_redirected_to new_session_path
  end
end
