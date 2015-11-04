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

ActiveRecord::Schema.define(version: 20151104043005) do

  create_table "challenges", force: :cascade do |t|
    t.integer  "player1id"
    t.integer  "player2id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "incoming"
  end

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "active",     default: true
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id"
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "games", force: :cascade do |t|
    t.integer  "player1id"
    t.integer  "player2id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "matches_won",    default: 0
    t.integer  "matches_lost",   default: 0
    t.integer  "points",         default: 0
    t.decimal  "rating",         default: 0.0
    t.integer  "number_ratings", default: 0
    t.string   "fb_id"
    t.string   "last_name"
  end

  add_index "users", ["fb_id"], name: "index_users_on_fb_id", unique: true

end
