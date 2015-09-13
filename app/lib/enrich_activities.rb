class EnrichActivities < Enrich

  def ids
    @ids ||= begin
      data.flat_map do |activities|
        activities['activities'].map do |activity|
          activity["object"].film.id if activity["object"].respond_to? 'film'
        end
      end
    end
  end

  def enrich
    # return data
    data.each do |activities|
      activities['activities'].delete_if {|a|  a["object"].class == String }
      activities['activities'].each do |activity|
          assign_values(activity["object"].film) if activity["object"].respond_to? 'film'
      end

    end
    data.delete_if {|a|  a['activities'].size == 0}
  end

  def assign_values(d)
    d.on_watchlist = watchlist_items.include?(d.id) 
    d.reviewed = review_items.include?(d.id) 
  end
  
end