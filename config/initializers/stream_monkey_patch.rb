Rails.configuration.to_prepare do
  module StreamRails
    class ActivityResult < Hash
      attr_accessor :enriched
      attr_reader :failed_to_enrich

      def initialize
        @failed_to_enrich = Hash.new
        super
      end

      def from_activity(h)
        self.merge(h)
      end

      def enriched?
        @failed_to_enrich.keys.length == 0
      end

      def not_enriched_fields
        @failed_to_enrich.keys
      end

      def track_not_enriched_field(field, value = nil)
        @failed_to_enrich[field] = value
      end

    end

    class Enrich
    

      def model_field?(field_value)
        if !field_value.respond_to?("split")
          return false
        end
        bits = field_value.split(':')
        if bits.length < 2
          return false
        end
        begin
          model = bits[0].split("Filmkeep\\").last
          model.classify.constantize
        rescue NameError
          return false
        else
          return true
        end
      end

      def collect_references(activities)
        model_refs = Hash.new{ |h,k| h[k] = Hash.new}
        activities.each do |activity|
          activity.select{|k,v| @fields.include? k.to_sym}.each do |field, value|
            next unless self.model_field?(value)
            model, id = value.split(':')
            model = model.split('Filmkeep\\').last
            model_refs[model][id] = 0
          end
        end
        model_refs
      end

      def inject_objects(activities, objects)
        activities = activities.map {|a| ActivityResult.new().from_activity(a)}
        activities.each do |activity|
          activity.select{|k,v| @fields.include? k.to_sym}.each do |field, value|
            next unless self.model_field?(value)
            model, id = value.split(':')
            model = model.split('Filmkeep\\').last
            activity[field] = objects[model][id] || value
            if objects[model][id].nil?
              activity.track_not_enriched_field(field, value)
            end
          end
        end
        activities
      end
    end

  end
end