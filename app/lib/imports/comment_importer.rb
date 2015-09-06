module Imports
  class CommentImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/comments.xml"
    end

    def slug
      'comments'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate comments")
    end

    def each_row(row)
      Comment.create({
        id: row['id'],
        user_id: row['user_id'],
        comment: row['comment'],
        commentable_id: row['commentable_id'],
        commentable_type: row['commentable_type'],
        spoiler: row['spoiler'],
        created_at: row['created_at'],
        updated_at: row['updated_at'],
        film_id: row['film_id']

        })
    end
  end
end