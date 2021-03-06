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

ActiveRecord::Schema.define(version: 20161118040951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "box_scores", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "one_point_attempt"
    t.integer  "one_point_make"
    t.integer  "two_point_attempt"
    t.integer  "two_point_make"
    t.integer  "three_point_attempt"
    t.integer  "three_point_make"
    t.integer  "turnovers"
    t.integer  "assists"
    t.integer  "fouls"
    t.integer  "rebounds"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "device_id"
    t.integer  "total_points"
  end

  create_table "games", force: :cascade do |t|
    t.string   "opponent"
    t.datetime "date"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "device_id"
  end

  create_table "player_photos", force: :cascade do |t|
    t.integer  "player_id"
    t.boolean  "profile_photo"
    t.string   "photo"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "team_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "device_id"
    t.integer  "height_feet"
    t.integer  "height_inches"
    t.string   "position"
    t.string   "school"
    t.string   "year"
    t.text     "athletic_accomplishments"
    t.text     "colleges_interested"
    t.string   "gpa"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "device_id"
    t.string   "slug"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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
    t.integer  "device_id"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
