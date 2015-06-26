class List < ActiveRecord::Base
  has_many :film_list
  has_many :films, :through => :film_list
end