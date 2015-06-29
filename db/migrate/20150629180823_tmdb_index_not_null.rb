class TmdbIndexNotNull < ActiveRecord::Migration
  def change
    change_column :films, :tmdb_id, :string, :null => false
    add_index :films, :tmdb_id, :name => "index_films_on_tmdb_id", :unique => true
  end
end
