class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def create
  end

  def edit
  end

  def show
    render json: User.includes(:followers).find(params[:id]) unless params[:username]

    user = User.find_by_username(params[:id])
    total_followers = Follower.where(follower_id: user.id).count
    total_following = user.followers.count
    total_reviews = user.reviews.count
    total_watchlist = user.watchlist.count

    hash = user.serializable_hash(only: [:id, :name, :username, :avatar]).tap do |h|
      h[:total_following] = total_following
      h[:total_followers] = total_followers
      h[:total_reviews] = total_reviews
      h[:total_watchlist] = total_watchlist
    end
    render json: hash
  end

  def update
  end

  def destroy
  end

  def search
    render json: User.where('name ilike ?', "%#{params[:query]}%")
  end

end