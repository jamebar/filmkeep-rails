class FilmList < ActiveRecord::Base
  self.table_name = 'film_list'
  belongs_to :list
  belongs_to :film 
end