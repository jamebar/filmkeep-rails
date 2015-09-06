module Imports
  class ListImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/lists.xml"
    end

    def slug
      'lists'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate lists")
    end

    def each_row(row)
      List.create({
        id: row['id'],
        user_id: row['user_id'],
        name: row['name'],
        description: row['description'],
        sort_order: row['sort_order'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
        })
    end
  end
end