class Rating < ActiveRecord::Base
  belongs_to :rating_type
  belongs_to :review
end