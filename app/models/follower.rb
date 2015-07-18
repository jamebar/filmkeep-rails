class Follower < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, class_name: 'User', foreign_key: 'follower_id'

  validates :user, presence: true

  include StreamRails::Activity
  as_activity

  def activity_notify
    [StreamRails.feed_manager.get_notification_feed(self.target.id)]
  end

  def activity_object
    self.target
  end
end