class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    photopost = Photopost.find(params[:photopost_id])
    current_user.favorite(photopost)
    flash[:success] = '投稿をお気に入りに追加しました'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    photopost = Photopost.find(params[:photopost_id])
    current_user.unfavorite(photopost)
    flash[:success] = '投稿をお気に入りから削除しました'
    redirect_back(fallback_location: root_path)
  end
end
