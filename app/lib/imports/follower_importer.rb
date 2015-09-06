module Imports
  class FollowerImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/followers.xml"
    end

    def slug
      'followers'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate followers")
    end

    def each_row(row)
      Follower.create({
        id: row['id'],
        user_id: row['user_id'],
        follower_id: row['follower_id'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
        })
    end
  end
end