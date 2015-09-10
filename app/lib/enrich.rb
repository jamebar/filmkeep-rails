class Enrich

  attr_accessor :data, :current_user
  def initialize(current_user, data, include_rotten = false)
    @current_user = current_user
    @data = data.is_a?(String) ? JSON.parse(data) : data
    @include_rotten = include_rotten
  end

  def ids
    @ids ||= begin
      ids = []
      Array.wrap(data).each do |d|
        next if d.nil?
        d = d.with_indifferent_access
        ids << d['id'] if d.has_key? "tmdb_id"

        ids << d['film']['id'] if d.has_key? "film"

        if d.has_key? "films"
          d['films'].each {|f| ids << f['id'] if f.has_key? "tmdb_id" }
        end

      end
      ids
    end
  end

  def enrich
    return data if current_user.nil?
    results = Array.wrap(data).map do |d|
      next if d.nil?
      d = d.with_indifferent_access
      d = assign_values(d) if d.has_key? "tmdb_id"

      d['film'] = assign_values(d['film']) if  d.has_key? "film"

      if d.has_key? "films"
        d['films'] = d['films'].map {|f| assign_values(f) if f.has_key? "tmdb_id" }
      end
      d
    end

    return data.is_a?(Array) ? results : results.first
  end

  def assign_values(d)
    d = d.with_indifferent_access
    d['on_watchlist'] = watchlist_items.include?(d['id']) 
    d['reviewed'] = review_items.include?(d['id']) 
    d['rotten'] = RottenService.new.rating(d['imdb_id']) if @include_rotten && d.has_key?('imdb_id')
    d
  end

  def watchlist_items
    @watchlist_items ||= Watchlist.where(user_id: current_user.id).where(film_id: ids).pluck(:film_id)
  end

  def review_items
    @review_items ||= Review.where(user_id: current_user.id).where(film_id: ids).pluck(:film_id)
  end


  
end