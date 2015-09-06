module Imports
  class RatingImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/ratings.xml"
    end

    def slug
      'ratings'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate ratings")
    end

    def each_row(row)
      Rating.create({
        id: row['id'],
        rating_type_id: row['rating_type_id'],
        review_id: row['review_id'],
        value: row['value'],
        created_at: row['create_at'],
        updated_at: row['updated_at']
        })
    end
  end
end