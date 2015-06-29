include RottenTomatoes

class RottenService

  def initialize
    Rotten.api_key = "gcu6mswmm3k7kevhmemu3uzd"
  end

  def film_by_imdb(id)
    Rails.cache.fetch("Rotten_find_#{id}", expires_in: 3.days) do
      RottenMovie.find(:imdb => id.to_s)
    end
  end

  def rating(id)
    Rails.cache.fetch("Rotten_critics_score_#{id}", expires_in: 3.days) do
      @movie = film_by_imdb(id.split('t').last)
      @movie.ratings.to_h if @movie.ratings
    end
  end

end