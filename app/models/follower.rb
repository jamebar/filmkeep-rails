class Follower < ActiveRecord::Base
  belongs_to :user

  include StreamRails::Activity
  as_activity

  def activity_verb
    'filmkeep\follower'
  end

  def activity_object
    self
  end
end