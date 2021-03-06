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

ActiveRecord::Schema.define(version: 20141118135027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "order_data", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "data_key_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_data", ["data_key_id", "resource_id"], name: "index_order_data_on_data_key_id_and_resource_id", unique: true, using: :btree
  add_index "order_data", ["data_key_id"], name: "index_order_data_on_data_key_id", using: :btree
  add_index "order_data", ["resource_id"], name: "index_order_data_on_resource_id", using: :btree

  create_table "order_data_keys", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_data_keys", ["name"], name: "index_order_data_keys_on_name", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount_full"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_data", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "data_key_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_data", ["data_key_id", "resource_id"], name: "index_user_data_on_data_key_id_and_resource_id", unique: true, using: :btree
  add_index "user_data", ["data_key_id"], name: "index_user_data_on_data_key_id", using: :btree
  add_index "user_data", ["resource_id"], name: "index_user_data_on_resource_id", using: :btree

  create_table "user_data_keys", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_data_keys", ["name"], name: "index_user_data_keys_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "order_data", "order_data_keys", column: "data_key_id", on_delete: :cascade
  add_foreign_key "order_data", "orders", column: "resource_id", on_delete: :cascade
  add_foreign_key "user_data", "user_data_keys", column: "data_key_id", on_delete: :cascade
  add_foreign_key "user_data", "users", column: "resource_id", on_delete: :cascade
end
