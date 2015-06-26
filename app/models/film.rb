class Film < ActiveRecord::Base
  has_many :film_list
  has_many :lists, :through => :film_list
end