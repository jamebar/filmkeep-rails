class WatchlistsController < ApplicationController
  def index
    watchlist = Watchlist.includes(:film).where(user_id: params[:user_id])
    output = watchlist.map {|w| w.serializable_hash }
    render json: Enrich.new(current_user, output).enrich 
  end

  def add_remove

  end

end