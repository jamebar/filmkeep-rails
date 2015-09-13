class EnrichFlatActivities < Enrich

  def ids
    @ids ||= begin
      data.flat_map do |activities|
          activities["object"].film.id if activities["object"].respond_to? 'film'
      end
    end
  end

  def enrich
    # return data
    data.map do |activities|
      assign_values(activities["object"].film) if activities["object"].respond_to? 'film'
      {
        activities: [activities],
        activity_count: 1,
        verb: activities.fetch('verb', ''),
        created_at: activities.fetch('time', ''),
        updated_at: activities.fetch('time', '')
      }
    end
  end

  def assign_values(d)
    d.on_watchlist = watchlist_items.include?(d.id) 
    d.reviewed = review_items.include?(d.id) 
  end
  
end