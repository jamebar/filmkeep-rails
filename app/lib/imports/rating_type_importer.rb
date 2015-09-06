module Imports
  class RatingTypeImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/rating_types.xml"
    end

    def slug
      'rating_types'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate rating_types")
    end

    def each_row(row)
      ::RatingType.create({
        id: row['id'],
        user_id: row['user_id'],
        label: row['label'],
        label_short: row['label_short'],
        sort_order: row['sort_order'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
        })
    end
  end
end