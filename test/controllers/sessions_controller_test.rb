require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_session_path
    assert_response :success
  end

  test "creates a new session" do
    user = User.create(attributes_for(:user))

    post session_path, params: { email: user.email, password: user.password }

    assert_redirected_to root_path
  end

  test "redirects to new session when authentication fails" do
    post session_path, params: { email: "local-part@domain", password: "password12%%AAzz" }

    assert_redirected_to new_session_path
  end

  test "redirects to new session when user is not authenticated" do
    get root_url

    assert_redirected_to new_session_path
  end

  test "redirects to the original URL after authentication" do
    User.create(attributes_for(:user))

    get root_url

    assert_redirected_to new_session_path
  end
end
