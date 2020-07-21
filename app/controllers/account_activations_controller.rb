class AccountActivationsController < ApplicationController
  # Before Actions
  before_action :load_user, only: %i(edit)

  # Activation Account By email
  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "controller.account_activations.edit.flash_success"
      redirect_to @user
    else
      flash[:danger] = t "controller.account_activations.edit.flash_fail"
      redirect_to root_url
    end
  end

  private

  # Before method

  # Before Actions
  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "controller.users.load_user.flash_user_nil"
    redirect_to root_path
  end
end
