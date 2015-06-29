class List < ActiveRecord::Base
  has_many :film_list
  has_many :films, :through => :film_list
  belongs_to :user

  include StreamRails::Activity
  as_activity

  def self.default_scope
    includes(:films, :user)
  end

  def serializable_hash(options={})
    options = { 
      :include => [:films, :user]
    }.update(options)
    super(options)
  end

end