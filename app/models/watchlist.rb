class Watchlist < ActiveRecord::Base
  belongs_to :film
  belongs_to :user
  
  include StreamRails::Activity
  as_activity
end