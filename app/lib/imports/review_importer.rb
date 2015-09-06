module Imports
  class ReviewImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/reviews.xml"
    end

    def slug
      'reviews'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate reviews")
    end

    def each_row(row)
      ::Review.create({
        id: row['id'],
        user_id: row['user_id'],
        film_id: row['film_id'],
        notes: row['notes'],
        seen_at: row['seen_at'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
        })
    end
  end
end