class RegistrationsController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.valid?
      redirect_to new_session_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
