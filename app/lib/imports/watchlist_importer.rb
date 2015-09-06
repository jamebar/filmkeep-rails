module Imports
  class WatchlistImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/watchlists.xml"
    end

    def slug
      'watchlists'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate watchlists")
    end

    def each_row(row)
      Watchlist.create({
        id: row['id'],
        user_id: row['user_id'],
        film_id: row['film_id'],
        sort_order: row['sort_order'],
        watched_at: row['watched_at'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
        })
    end
  end
end