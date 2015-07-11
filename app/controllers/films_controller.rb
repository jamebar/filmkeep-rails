class FilmsController < ApplicationController
  def index
    output = Film.digest(params[:tmdb_id].split('-').first).first.serializable_hash
    render json: Enrich.new(current_user, output, true).enrich  
  end

  def now_playing
    results = ExternalFilmService.now_playing
    output = results.map {|k| k.serializable_hash }
    render json: Enrich.new(current_user, output).enrich  
  end

  def search
    results = ExternalFilmService.search(params[:query])
    render json: results
  end

  def trailer
    render json: ExternalFilmService.trailer(params[:tmdb_id])
  end

end