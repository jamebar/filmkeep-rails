class Bootstrapper

  def initialize(user)
    @current_user = user
  end

  def me
    User.includes('followers').where(id: @current_user.id).first
  end

  def announcements
    Announcement.where(is_active: true)
  end

  def agg_feed
    @agg_feed ||= StreamRails.feed_manager.get_news_feeds(@current_user.id)[:aggregated]
  end

  def notif_feed
    @notif_feed ||= StreamRails.feed_manager.get_notification_feed(@current_user.id)
  end

  def to_h
    {
      me: me.serializable_hash.tap do |h|
            h[:new] = me.reviews.count < 1
            h[:followers] = me.followers
          end,
      announcements: announcements,
      stream: {
        id: StreamRails.config.api_site_id,
        key: StreamRails.config.api_key,
        notif_token: notif_feed.token,
        agg_token: agg_feed.token,
      }
    }
    
  end
end