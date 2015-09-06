class StreamController < ApplicationController
  before_action :authenticate_user!
  def index
    enricher = Extensions::Enrich.new
    feed = StreamRails.feed_manager.get_news_feeds(current_user.id)[:aggregated]
    results = feed.get(:limit=>10, :offset=>0)['results']
    activities = enricher.enrich_aggregated_activities(results)
    render json: EnrichActivities.new(current_user, activities).enrich 
  end

  

end