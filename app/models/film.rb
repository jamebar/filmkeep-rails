class Film < ActiveRecord::Base
  has_many :film_list
  has_many :lists, :through => :film_list

  attr_accessor :on_watchlist, :reviewed

  def serializable_hash(options={})
    options = { 
      :on_watchlist => on_watchlist,
      :reviewed => reviewed
    }
    super.merge(options)
  end

  def self.digest(ids)
    ids = Array.wrap(ids)
    films = where(tmdb_id: ids).index_by(&:tmdb_id)
    return ids.map{|i| films[i.to_s] } if films.length == ids.count
    ids.map do |id| 
      f = films.fetch(id.to_s, nil) 
      parse(id) if f.nil?
    end
  end

  def self.parse(id)
    film_from_external = ExternalFilmService.film_by_id(id)

    create(
      tmdb_id: film_from_external.id,
      title: film_from_external.title,
      poster_path: film_from_external.poster_path, 
      backdrop_path: film_from_external.backdrop_path, 
      imdb_id: film_from_external.imdb_id, 
      release_date: film_from_external.release_date, 
      summary: film_from_external.overview, 
      certification: film_from_external.try(:releases).select {|c| c.iso_3166_1 == 'US'}.first.try(:certification)
    )
  end
end