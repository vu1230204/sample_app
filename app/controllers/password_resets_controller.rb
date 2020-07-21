class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  before_action :check_password_blank, only: %i(update)

  I18N_PATH = I18n.t "controller.password_resets"
  # Control view new
  def new; end

  # Post email
  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      # SEND EMAIL
      @user.create_reset_digest
      @user.send_password_reset_email
      flash.now[:success] = I18N_PATH[:create][:flash_success]
      redirect_to root_path
    else
      flash.now[:danger] = I18N_PATH[:create][:flash_fail]
      render :new
    end
  end

  # Control view edit
  def edit; end

  # Update password reset for database
  def update
    if @user.update user_params
      log_in @user
      flash.now[:success] = I18N_PATH[:update][:flash_success]
      @user.create_reset_digest
      redirect_to @user
    else
      flash.now[:danger] = I18N_PATH[:update][:flash_fail]
      render :edit
    end
  end

  private

  def check_password_blank
    return unless params[:user][:password].empty?

    @user.errors.add(:password, I18N_PATH[:update][:valid])
    render :edit
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash.now[:danger] = I18N_PATH[:check_expiration][:flash_danger]
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash.now[:danger] = I18N_PATH[:check_expiration][:flash_danger]
    redirect_to root_path
  end

  def check_expiration
    return if @user.password_reset_expired?

    flash[:danger] = I18N_PATH[:check_expiration][:flash_danger]
    redirect_to new_password_reset_url
  end
end
