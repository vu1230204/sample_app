class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  I18N_PATH = I18n.t "controller.microposts"
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = I18N_PATH[:create][:flash_success]
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = I18N_PATH[:destroy][:flash_success]
    else
      flash[:danger] = I18N_PATH[:destroy][:flash_fail]
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost
    flash[:danger] = I18N_PATH[:correct_user][:flash_fail]
    redirect_to root_url
  end
end
