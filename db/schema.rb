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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110801195750) do

  create_table "games", :force => true do |t|
    t.integer  "rounds_played"
    t.integer  "total_rounds",  :null => false
    t.integer  "winner"
    t.integer  "player1",       :null => false
    t.integer  "player2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["player1"], :name => "index_games_on_player1"
  add_index "games", ["player2"], :name => "index_games_on_player2"
  add_index "games", ["winner"], :name => "index_games_on_winner"

  create_table "games_stats", :id => false, :force => true do |t|
    t.integer "game_id"
    t.integer "stats_id"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "game_id"
    t.integer  "num_round"
    t.integer  "winner",     :null => false
    t.integer  "player1",    :null => false
    t.integer  "player2",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "curScore1"
    t.integer  "curScore2"
  end

  add_index "rounds", ["game_id"], :name => "index_rounds_on_game_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stats", :force => true do |t|
    t.integer  "wins",         :default => 0, :null => false
    t.integer  "games_played", :default => 0, :null => false
    t.integer  "user_id",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rocks",        :default => 0, :null => false
    t.integer  "papers",       :default => 0, :null => false
    t.integer  "scissors",     :default => 0, :null => false
  end

  add_index "stats", ["user_id"], :name => "index_stats_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",                           :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "falied_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end
