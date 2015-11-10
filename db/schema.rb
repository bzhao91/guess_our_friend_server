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

ActiveRecord::Schema.define(version: 20151110004256) do

  create_table "challenges", force: :cascade do |t|
    t.integer  "challenger_id"
    t.integer  "challengee_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "challenges", ["challengee_id", "challenger_id"], name: "index_challenges_on_challengee_id_and_challenger_id", unique: true
  add_index "challenges", ["challengee_id"], name: "index_challenges_on_challengee_id"
  add_index "challenges", ["challenger_id", "challengee_id"], name: "index_challenges_on_challenger_id_and_challengee_id", unique: true
  add_index "challenges", ["challenger_id"], name: "index_challenges_on_challenger_id"

  create_table "friend_pools", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.boolean  "grey"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friend_pools", ["game_id"], name: "index_friend_pools_on_game_id"
  add_index "friend_pools", ["user_id"], name: "index_friend_pools_on_user_id"

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "active",     default: true
  end

  add_index "friendships", ["friend_id", "user_id"], name: "index_friendships_on_friend_id_and_user_id", unique: true
  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id"
  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "games", force: :cascade do |t|
    t.integer  "player1id"
    t.integer  "player2id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "active_move",     default: true
    t.boolean  "lock",            default: false
    t.boolean  "bad_guess",       default: false
    t.integer  "mystery_friend1"
    t.integer  "mystery_friend2"
  end

  add_index "games", ["player1id", "player2id"], name: "index_games_on_player1id_and_player2id", unique: true
  add_index "games", ["player1id"], name: "index_games_on_player1id"
  add_index "games", ["player2id", "player1id"], name: "index_games_on_player2id_and_player1id", unique: true
  add_index "games", ["player2id"], name: "index_games_on_player2id"

  create_table "questions", force: :cascade do |t|
    t.text     "content"
    t.integer  "answer",     default: -1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "games_id"
    t.integer  "users_id"
  end

  add_index "questions", ["games_id"], name: "index_questions_on_games_id"
  add_index "questions", ["users_id"], name: "index_questions_on_users_id"

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
