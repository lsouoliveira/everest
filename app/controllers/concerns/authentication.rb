module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  private
  def require_authentication
    return if current_user
    puts "User not authenticated. Redirecting to login page."
    # Store the URL the user was trying to access
    puts "Storing return URL: #{request.url}"

    session[:return_to_after_authentication] = request.url
    redirect_to new_session_path
  end

  def start_new_session_for(user)
    session[:user_email] = user.email
  end

  def terminate_session
    session.delete(:user_email)
  end

  def after_authentication_url
    session.delete(:return_to_after_authentication) || root_path
  end

  def current_user
    return if session[:user_email].blank?

    @_current_user ||= $user_repository.find_by_id(session[:user_email])
  rescue UserRepository::NotFound
    nil
  end
end
