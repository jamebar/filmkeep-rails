class InitialMigration < ActiveRecord::Migration
  def change
    create_table "films", force: true do |t|
      t.string "title", null: false
      t.integer "rotten_id"
      t.integer "tmdb_id"
      t.integer "imdb_id"
      t.string "release_date"
      t.string "poster_path"
      t.string "backdrop_path"
      t.text "summary"
      t.string "certification"
      t.timestamps
      t.index ["tmdb_id"], :name => "index_films_on_tmdb_id", :unique => true
    end

    create_table "film_list", force: true do |t|
      t.integer "film_id"
      t.integer "list_id"
      t.timestamps
      t.integer "sort_order"
    end

    create_table "announcements", force: true do |t|
      t.text :description
      t.string :title
      t.string :link
      t.boolean :is_active
      t.timestamps
    end

    create_table "comments", force: true do |t|
      t.integer :user_id
      t.text :comment
      t.integer :commentable_id
      t.string :commentable_type
      t.boolean :spoiler
      t.timestamps
      t.integer :film_id
    end

    create_table "followers", force: true do |t|
      t.integer :user_id
      t.integer :follower_id
      t.timestamps
      t.index ["user_id"], :name => "index_followers_on_user_id", :unique => false
      t.index ["follower_id"], :name => "index_followers_on_follower_id", :unique => false
    end

    create_table "lists", force: true do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.integer :sort_order
      t.timestamps
    end

    create_table "rating_types", force: true do |t|
      t.integer :user_id
      t.string :label
      t.string :label_short
      t.integer :sort_order
      t.timestamps
    end

    create_table "ratings", force: true do |t|
      t.integer :rating_type_id
      t.integer :review_id
      t.float :value
      t.timestamps
      t.index ["rating_type_id"], :name => "index_ratings_on_rating_type_id", :unique => false
      t.index ["review_id"], :name => "index_ratings_on_review_id", :unique => false
    end

    create_table "reviews", force: true do |t|
      t.integer :user_id
      t.integer :film_id
      t.text :notes
      t.datetime  :seen_at
      t.timestamps
      t.index ["user_id"], :name => "index_reviews_on_user_id", :unique => false
      t.index ["film_id"], :name => "index_reviews_on_film_id", :unique => false
    end

    create_table "watchlists", force: true do |t|
      t.integer :user_id
      t.integer :film_id
      t.integer :sort_order
      t.datetime :watched_at
      t.timestamps
      t.index ["user_id","film_id"], :name => "index_watchlists_on_user_id_and_film_id", :unique => false
      t.index ["user_id"], :name => "index_watchlists_on_user_id", :unique => false
    end
  end
end
