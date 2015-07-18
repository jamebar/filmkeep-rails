class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index

    notification_feed = StreamRails.feed_manager.get_notification_feed(current_user.id)
    enricher = StreamRails::Enrich.new
    results = notification_feed.get()['results']
    activities = enricher.enrich_aggregated_activities(results)
    render json: activities
  end

  def mark_seen
    notification_feed = StreamRails.feed_manager.get_notification_feed(current_user.id)
    result = notification_feed.get(:limit=>5, :offset=>0, :mark_seen=>true)
    render json: {response: true}
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

end