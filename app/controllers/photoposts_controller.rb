class PhotopostsController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :new, :create, :destroy]
  before_action :correct_user, only: [:destroy]
  
  def show
    @photopost = Photopost.find(params[:id])
  end

  def new
    @photopost = current_user.photoposts.build
  end

  def create
    @photopost = current_user.photoposts.build(photopost_params)
    if @photopost.save
      flash[:success] = '写真を投稿しました。'
      redirect_to root_url
    else
      @photoposts = current_user.feed_photoposts.order(id: :desc).page(params[:page]).per(10)
      flash.now[:danger] = '写真の投稿に失敗しました。'
      render :new
    end
  end

  def destroy
    @photopost.destroy
    flash[:success] = '投稿を削除しました。'
    redirect_to root_url
  end
  
  def search
    if params[:title].present?
      @photoposts = Photopost.where('title LIKE ?', "%#{params[:title]}%").page(params[:page]).per(10)
    else
      @photoposts = Photopost.order(id: :desc).page(params[:page]).per(10)
    end
  end
  
  private
  
  def photopost_params
    params.require(:photopost).permit(:title, :image)
  end

  def correct_user
    @photopost = current_user.photoposts.find_by(id: params[:id])
    unless @photopost
      redirect_to root_url
    end
  end
end
