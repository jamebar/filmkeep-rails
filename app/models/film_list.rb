class FilmList < ActiveRecord::Base
  self.table_name = 'film_list'
  belongs_to :list
  belongs_to :film 

  # def serializable_hash(options={})
  #   options = { 
  #     :filmdd => film
  #   }
  #   super.merge(options)
  # end

end