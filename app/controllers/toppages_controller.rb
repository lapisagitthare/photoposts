class ToppagesController < ApplicationController
  def index
    if logged_in?
      @photoposts = current_user.feed_photoposts.order(id: :desc).page(params[:page]).per(10)
    else
      @photoposts = Photopost.all.order(id: :desc).page(params[:page]).per(10)
    end
  end
end