module Imports
  class UserImporter
    include Importer
    def glob
      "#{ENV.fetch('import_base_dir')}/users.xml"
    end

    def slug
      'users'
    end

    def archive_dir
      ENV.fetch('import_archive_dir')
    end

    def truncate!
      ActiveRecord::Base.connection.execute("truncate users")
    end

    def each_row(row)
      row.each{|k,v| row[k] = '' if v == 'NULL' }
      conf_token = rand(100000...999999999)
      created_at = row['created_at'] == '0000-00-00 00:00:00' ? Time.now() : row['created_at']
      updated_at = row['updated_at'] == '0000-00-00 00:00:00' ? Time.now() : row['updated_at']
      password = row['password'].sub('$2y$10', '$2a$10')
      sql = "insert into users (id, name, username, avatar, email, encrypted_password, confirmation_token, confirmed_at, created_at, updated_at, facebook_id, google_oauth2_id) VALUES( #{row['id']}, #{ActiveRecord::Base.connection.quote(row['name'])}, '#{row['username']}', '#{row['avatar']}', '#{row['email']}', '#{password}', '#{conf_token}', '#{created_at}', '#{created_at}', '#{updated_at}', '#{row['facebook_id']}', '#{row['google_id']}' )"
     
      ActiveRecord::Base.connection.execute(sql)
    end


  end
end