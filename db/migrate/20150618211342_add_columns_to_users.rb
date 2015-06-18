class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :string
    add_column :users, :google_oauth2_id, :string
  end
end
