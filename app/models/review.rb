class Review < ActiveRecord::Base
  belongs_to :film
  belongs_to :user
  has_many :ratings , -> { order(rating_type_id: :asc) }

  include StreamRails::Activity
  as_activity

  def self.default_scope
    includes(:film, ratings: :rating_type)
  end

  def serializable_hash(options={})
    options = { 
      :include => {film: {}, ratings: {:include => :rating_type}}
    }.update(options)
    super(options)
  end

  def activity_object
    self
  end
end