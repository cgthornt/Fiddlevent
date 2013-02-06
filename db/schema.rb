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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120912172118) do

  create_table "event_subscriptions", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "phone_number"
    t.string   "ip_address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "merchant_id"
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.datetime "time_start"
    t.datetime "time_stop"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "filter_set_id"
    t.string   "fb_event_id"
    t.string   "event_image_file_name"
    t.integer  "event_image_file_size"
    t.datetime "event_image_updated_at"
    t.string   "event_image_content_type"
  end

  add_index "events", ["filter_set_id"], :name => "index_events_on_filter_set_id"
  add_index "events", ["location_id"], :name => "events_location_id_fk"
  add_index "events", ["merchant_id"], :name => "events_merchant_id_fk"
  add_index "events", ["time_start"], :name => "index_events_on_time_start"
  add_index "events", ["time_stop"], :name => "index_events_on_time_stop"

  create_table "filter_sets", :force => true do |t|
    t.integer  "merchant_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "filter_sets", ["merchant_id"], :name => "index_filter_sets_on_merchant_id"

  create_table "filter_sets_filters", :id => false, :force => true do |t|
    t.integer "filter_id"
    t.integer "filter_set_id"
  end

  add_index "filter_sets_filters", ["filter_id", "filter_set_id"], :name => "index_filters_filter_sets_on_filter_id_and_filter_set_id"
  add_index "filter_sets_filters", ["filter_set_id"], :name => "filter_sets_filters_filter_set_id_fk"

  create_table "filters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group_name"
    t.integer  "position"
  end

  add_index "filters", ["group_name", "position"], :name => "index_filters_on_group_name_and_position"
  add_index "filters", ["group_name"], :name => "index_filters_on_group_name"
  add_index "filters", ["position", "group_name"], :name => "index_filters_on_position_and_group_name"
  add_index "filters", ["position"], :name => "index_filters_on_position"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.integer  "state_id"
    t.integer  "zip"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "location_image_file_name"
    t.integer  "location_image_file_size"
    t.datetime "location_image_updated_at"
    t.string   "location_image_content_type"
  end

  add_index "locations", ["latitude", "longitude"], :name => "index_locations_on_latitude_and_longitude"
  add_index "locations", ["merchant_id"], :name => "locations_merchant_id_fk"
  add_index "locations", ["state_id"], :name => "locations_state_id_fk"

  create_table "merchants", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "merchant_image_file_name"
    t.integer  "merchant_image_file_size"
    t.datetime "merchant_image_updated_at"
    t.string   "merchant_image_content_type"
  end

  add_index "merchants", ["user_id"], :name => "index_merchants_on_user_id"

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "system_name"
    t.boolean "assignable",  :default => true
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "roles", ["system_name"], :name => "index_roles_on_system_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id"], :name => "roles_users_user_id_fk"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "events", "filter_sets", :name => "events_filter_set_id_fk", :dependent => :nullify
  add_foreign_key "events", "locations", :name => "events_location_id_fk", :dependent => :nullify
  add_foreign_key "events", "merchants", :name => "events_merchant_id_fk", :dependent => :nullify

  add_foreign_key "filter_sets", "merchants", :name => "filter_sets_merchant_id_fk", :dependent => :nullify

  add_foreign_key "filter_sets_filters", "filter_sets", :name => "filter_sets_filters_filter_set_id_fk", :dependent => :nullify
  add_foreign_key "filter_sets_filters", "filters", :name => "filter_sets_filters_filter_id_fk", :dependent => :nullify

  add_foreign_key "locations", "merchants", :name => "locations_merchant_id_fk", :dependent => :nullify
  add_foreign_key "locations", "states", :name => "locations_state_id_fk", :dependent => :nullify

  add_foreign_key "merchants", "users", :name => "merchants_user_id_fk", :dependent => :nullify

  add_foreign_key "roles_users", "roles", :name => "roles_users_role_id_fk", :dependent => :nullify
  add_foreign_key "roles_users", "users", :name => "roles_users_user_id_fk", :dependent => :nullify

end
