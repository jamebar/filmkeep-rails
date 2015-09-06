module Imports
  class FilmListImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/film_list.xml"
    end

    def slug
      'film_list'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate film_list")
    end

    def each_row(row)
      FilmList.create({
        id: row['id'],
        film_id: row['film_id'],
        list_id: row['list_id'],
        sort_order: row['sort_order'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
        })
    end
  end
end