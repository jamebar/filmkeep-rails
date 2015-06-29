class Watchlist < ActiveRecord::Base
  belongs_to :film
  belongs_to :user

  def self.default_scope
    includes(:film)
  end

  def serializable_hash(options={})
    options = { 
      :include => :film
    }.update(options)
    super(options)
  end
  
  include StreamRails::Activity
  as_activity
end