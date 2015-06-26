class ChangeIdTypes < ActiveRecord::Migration
  def change
    remove_column :films, :rotten_id
    remove_column :films, :tmdb_id
    remove_column :films, :imdb_id
    add_column :films, :rotten_id, :string, :after => :title
    add_column :films, :tmdb_id, :string, :after => :rotten_id
    add_column :films, :imdb_id, :string, :after => :tmdb_id
  end
end
