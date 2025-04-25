module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :current_user
  end

  private
  def require_authentication
    return if current_user

    session[:return_to_after_authentication] = request.url
    redirect_to new_session_path
  end

  def redirect_if_authenticated
    return unless current_user

    redirect_to home_path
  end

  def start_new_session_for(user)
    session[:user_id] = user.id
  end

  def terminate_session
    session.delete(:user_id)
  end

  def after_authentication_url
    session.delete(:return_to_after_authentication) || root_path
  end

  def current_user
    return if session[:user_id].blank?

    @_current_user ||= $user_repository.find_by_id(session[:user_id])
  rescue UserRepository::NotFound
    nil
  end
end
