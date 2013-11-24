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

ActiveRecord::Schema.define(version: 20131106135911) do

  create_table "calendars", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "friends", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "friend_id"
  end

  create_table "group_members", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.integer "is_leader"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_groups", force: true do |t|
    t.string "name"
  end

  create_table "problems", force: true do |t|
    t.string  "name"
    t.integer "difficulty"
    t.date    "end_date"
  end

  create_table "records", force: true do |t|
    t.date     "start_time"
    t.date     "end_time"
    t.integer  "difficulty"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subproblems", id: false, force: true do |t|
    t.integer "child_id"
    t.integer "parent_id"
  end

  create_table "targets", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "problem_id"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workers", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "problem_id"
  end

end