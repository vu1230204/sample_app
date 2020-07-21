class UsersController < ApplicationController
  # Before Action
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  # Show All Users
  def index
    @users = User.paginate page: params[:page]
  end

  # Show User
  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # Get Singup User
  def new
    @user = User.new
  end

  # Post Signup User
  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      @user.send_activation_email
      flash[:info] = t "controller.users.create.flash_check_email"
      redirect_to root_path
    else
      render :new
    end
  end

  # Get Update User
  def edit; end

  # Post Update User
  def update
    if @user.update(user_params)
      flash[:success] = t "controller.users.update.flash_success"
      redirect_to @user
    else
      flash[:danger] = t "controller.users.update.flash_fail"

      render :edit
    end
  end

  # Delete User
  def destroy
    if @user.destroy
      flash[:success] = t "controller.users.destroy.flash_success"

    else
      flash[:danger] = t "controller.users.destroy.flash_fail"

    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # Verify Admin
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  # Find User by Id
  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "controller.users.load_user.flash_user_nil"
    redirect_to root_path
  end
end
