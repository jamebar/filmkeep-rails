class Film < ActiveRecord::Base
  has_many :film_list
  has_many :lists, :through => :film_list

  attr_accessor :on_watchlist, :reviewed

  def self.digest(ids)
    ids = Array.wrap(ids)
    films = where(tmdb_id: ids)
    return films if films.length == ids.count

    results = []
    [*ids].each do |id|
      f = films.select{|k| k.tmdb_id.to_s == id.to_s}.first
      f = parse(id) if f.nil?
      results << f
    end
    results

  end

  def self.parse(id)
    film_from_external = ExternalFilmService.new.film_by_id(id)
    
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