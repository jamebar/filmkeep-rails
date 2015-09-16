class Comment < ActiveRecord::Base
  belongs_to :film
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  include StreamRails::Activity
  as_activity

  def self.default_scope
    includes(:film, :user)
  end

  def serializable_hash(options={})
    options = { 
      :include => [:film, :user]
    }.update(options)
    super(options)
  end

  def activity_extra_data
    {'title' => commentable.title}
  end

  def activity_object
    self
  end

  def activity_notify
    user_ids = []
    owner_id = commentable.user_id
    user_ids << owner_id unless User.current.id == owner_id

    commentable.comments.each do |c|
      user_ids << c.user_id unless User.current.id = c.user_id
    end

    unique_ids = user_ids.uniq
    unique_ids.map{|u| StreamRails.feed_manager.get_notification_feed(u)}

  end

end