# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150629180823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "announcements", force: :cascade do |t|
    t.text     "description"
    t.string   "title"
    t.string   "link"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "spoiler"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "film_id"
  end

  create_table "film_list", force: :cascade do |t|
    t.integer  "film_id"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order"
  end

  create_table "films", force: :cascade do |t|
    t.string   "title",         null: false
    t.string   "release_date"
    t.string   "poster_path"
    t.string   "backdrop_path"
    t.text     "summary"
    t.string   "certification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rotten_id"
    t.string   "tmdb_id",       null: false
    t.string   "imdb_id"
  end

  add_index "films", ["tmdb_id"], name: "index_films_on_tmdb_id", unique: true, using: :btree

  create_table "followers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followers", ["follower_id"], name: "index_followers_on_follower_id", using: :btree
  add_index "followers", ["user_id"], name: "index_followers_on_user_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rating_types", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "label"
    t.string   "label_short"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "rating_type_id"
    t.integer  "review_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["rating_type_id"], name: "index_ratings_on_rating_type_id", using: :btree
  add_index "ratings", ["review_id"], name: "index_ratings_on_review_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "film_id"
    t.text     "notes"
    t.datetime "seen_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["film_id"], name: "index_reviews_on_film_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "avatar"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "facebook_id"
    t.string   "google_oauth2_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "watchlists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "film_id"
    t.integer  "sort_order"
    t.datetime "watched_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watchlists", ["user_id", "film_id"], name: "index_watchlists_on_user_id_and_film_id", using: :btree
  add_index "watchlists", ["user_id"], name: "index_watchlists_on_user_id", using: :btree

end
