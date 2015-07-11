class WatchlistsController < ApplicationController
  def index
    watchlist = Watchlist.includes(:film).where(user_id: params[:user_id])
    output = watchlist.map {|w| w.serializable_hash }
    render json: Enrich.new(current_user, output).enrich 
  end

  def add_remove
    action = 'added'
    user_id = current_user.id
    results = Watchlist.where(film_id: params[:film_id], user_id: user_id).first
    if results
      results.destroy
      action = 'removed'
    else
      Watchlist.create!(user_id: user_id, film_id: params[:film_id])
    end

    render json: {action: action}

  end

end