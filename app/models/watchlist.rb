class Watchlist < ActiveRecord::Base
  belongs_to :film
  belongs_to :user
  has_many :comments,  as: :commentable

  def self.default_scope
    includes(:film, :comments)
  end

  def serializable_hash(options={})
    options = { 
      :include => [:film, :comments]
    }.update(options)
    super(options)
  end
  
  def title
    film.title
  end
  include StreamRails::Activity
  as_activity

  def activity_object
    self
  end
end