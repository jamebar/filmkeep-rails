class StreamController < ApplicationController
  def index
    enricher = Extensions::Enrich.new
    feed = StreamRails.feed_manager.get_news_feeds(current_user.id)[:aggregated]
    results = feed.get(:limit=>5, :offset=>0)['results']
    activities = enricher.enrich_aggregated_activities(results)
    render json: activities
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