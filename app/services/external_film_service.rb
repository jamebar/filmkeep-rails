class ExternalFilmService
  class << self

    def image_config
      Enceladus::Configuration::Image.instance
    end

    def trailer(id)
      film_by_id(id).youtube_trailers
    end

    def film_by_id(id)
      Rails.cache.fetch("EFS_find_#{id}", expires_in: 3.days) do
        Enceladus::Movie.find(id)
      end
    end

    def search(query)
      Rails.cache.fetch("EFS_query_#{query}", expires_in: 7.days) do
        Enceladus::Movie.find_by_title(query).results_per_page.first
      end
    end


    def now_playing
      Rails.cache.fetch('EFS_nowplaying', expires_in: 1.day) do 
        films = Enceladus::Movie.now_playing.results_per_page.first
        Film.digest(films.map(&:id))
      end
    end
  end
end