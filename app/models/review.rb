class Review < ActiveRecord::Base
  belongs_to :film
  belongs_to :user
  has_many :ratings , -> { order(rating_type_id: :asc) }
  has_many :comments,  as: :commentable

  include StreamRails::Activity
  as_activity

  def self.default_scope
    includes(:film, :comments, :user, ratings: :rating_type)
  end

  def serializable_hash(options={})
    options = { 
      :include => {film: {}, ratings: {:include => :rating_type}, comments: {}, user:{}}
    }.update(options)
    super(options)
  end

  def activity_object
    self
  end
end