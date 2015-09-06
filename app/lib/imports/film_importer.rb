module Imports
  class FilmImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/films.xml"
    end

    def slug
      'films'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate films")
    end

    def each_row(row)
      Film.create({
        id: row['id'],
        title: row['title'],
        release_date: row['release_date'],
        poster_path: row['poster_path'],
        backdrop_path: row['backdrop_path'],
        summary: row['summary'],
        certification: row['certification'],
        created_at: row['created_at'],
        updated_at: row['updated_at'],
        rotten_id: row['rotten_id'],
        tmdb_id: row['tmdb_id'],
        imdb_id: row['imdb_id']
        })
    end
  end
end