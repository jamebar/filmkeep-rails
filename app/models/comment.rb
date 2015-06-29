class Comment < ActiveRecord::Base
  belongs_to :film
  belongs_to :user

  include StreamRails::Activity
  as_activity

  def self.default_scope
    includes(:film)
  end

  def serializable_hash(options={})
    options = { 
      :include => :film
    }.update(options)
    super(options)
  end

  def activity_lazy_loading
    [:film]
  end

end