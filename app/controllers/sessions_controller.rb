class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]
  before_action :redirect_if_authenticated, only: [ :new, :create ]

  def new; end

  def create
    if user = User.authenticate_by(session_params)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: t(".error")
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private
  def session_params
    params.permit(:email, :password)
  end
end
