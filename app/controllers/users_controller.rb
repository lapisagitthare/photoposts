class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show]
  before_action :correct_user, only: [:edit ,:update, :followings, :followers]
  
  def show
    @user = User.find_by(name: params[:name])
    @photoposts = @user.photoposts.order(id: :desc).page(params[:page]).per(10)
    counts(@user)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find_by(name: params[:name])
  end

  def update
    @user = User.find_by(name: params[:name])
    
    if @user.update(user_params)
      flash[:success] = '登録情報は正常に更新されました'
      redirect_to @user
    else
      flash.now[:danger] = '登録情報は更新されませんでした'
      render :edit
    end
  end
  
  def followings
    @user = User.find_by(name: params[:name])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find_by(name: params[:name])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def favorites
    @user = User.find_by(name: params[:name])
    @photoposts = @user.favorite_photoposts.page(params[:page]).per(10)
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :icon, :password, :password_confirmation)
  end
  
  def correct_user
    @user = current_user
    unless @user
      redirect_to root_url
    end
  end
  
end