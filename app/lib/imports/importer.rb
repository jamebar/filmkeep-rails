module Imports
  module Importer
    extend ActiveSupport::Concern
    
    included do
      extend ActiveModel::Callbacks
      define_model_callbacks :process
      after_process :set_sequence_id
    end

    module ClassMethods
      def process!
        self.new.process!
      end
    end

    def required_method
      raise NotImplementedError, "classes that include Import::Importer must implement #{__method__}"
    end

    def file_handler
      @fh ||= FileHandler.new(glob: glob, archive_dir: archive_dir)
    end

    def process!
      truncate!
      file_handler.each_file do |file, report|
        run_callbacks :process do
          f = File.open(file);
          p = Crack::XML.parse(f.read )
          each_chunk p['filmkeep_production'][slug]['row']
         
        end
      end
    end

    def each_chunk(chunk)
      chunk.each do |row| 
          each_row(row)
      end
    end

    def set_sequence_id
      ActiveRecord::Base.connection.execute("SELECT setval('#{slug}_id_seq', (SELECT MAX(id) from \"#{slug}\"));")
    end
  end
end