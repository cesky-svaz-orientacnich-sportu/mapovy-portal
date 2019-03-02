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

ActiveRecord::Schema.define(version: 20150409051302) do

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: true do |t|
    t.string   "note"
    t.string   "full_name"
    t.text     "club"
    t.string   "activity"
    t.integer  "year_of_birth"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "cartographers", force: true do |t|
    t.integer  "map_id"
    t.integer  "author_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clubs", force: true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.string   "region"
    t.string   "district"
    t.string   "url"
    t.string   "division"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "oris_data_json"
    t.string   "slug"
  end

  add_index "clubs", ["slug"], name: "index_clubs_on_slug", unique: true, using: :btree

  create_table "issue_reports", force: true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "resolved",   default: false, null: false
  end

  create_table "map_collection_memberships", force: true do |t|
    t.integer  "map_id"
    t.integer  "map_collection_id"
    t.integer  "year"
    t.string   "note"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "map_collections", force: true do |t|
    t.string   "title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "slug"
    t.text     "description"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "map_collections", ["slug"], name: "index_map_collections_on_slug", unique: true, using: :btree

  create_table "map_layers", force: true do |t|
    t.integer  "layer_index"
    t.string   "title_cs"
    t.string   "title_en"
    t.string   "color"
    t.boolean  "visible_by_default"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "maps", force: true do |t|
    t.string   "title"
    t.string   "patron"
    t.string   "patron_accuracy"
    t.integer  "year"
    t.string   "year_accuracy"
    t.integer  "scale"
    t.string   "archive_print1_class"
    t.string   "archive_print2_class"
    t.string   "archive_print3_class"
    t.integer  "archive_extra_print_count"
    t.float    "equidistance"
    t.string   "identifier_other"
    t.string   "locality"
    t.float    "area_size"
    t.string   "issued_by"
    t.string   "printed_by"
    t.string   "map_type"
    t.string   "drawing_technique"
    t.string   "printing_technique"
    t.string   "resource"
    t.string   "main_race_title"
    t.date     "main_race_date"
    t.text     "administrator"
    t.string   "identifier_approval"
    t.string   "identifier_filing"
    t.text     "note_public"
    t.text     "note_internal"
    t.string   "preview_identifier"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "created_by_id"
    t.string   "map_family"
    t.string   "map_sport"
    t.integer  "oris_event_id"
    t.text     "shape_json"
    t.text     "shape_kml"
    t.string   "georeference"
    t.string   "region"
    t.string   "state"
    t.text     "record_log"
    t.integer  "approved_by_id"
    t.string   "mapping_state"
    t.string   "slug"
    t.boolean  "has_jpg",                   default: false, null: false
    t.boolean  "has_kml",                   default: false, null: false
    t.string   "administrator_email"
    t.date     "last_reminder_sent_at"
    t.date     "state_changed_at"
    t.integer  "completed_by_id"
  end

  add_index "maps", ["slug"], name: "index_maps_on_slug", unique: true, using: :btree

  create_table "oris_events", force: true do |t|
    t.integer  "oris_id"
    t.date     "date"
    t.string   "title"
    t.text     "oris_json",         limit: 2147483647
    t.string   "place"
    t.datetime "oris_timestamp"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "obpostupy_url"
    t.string   "obpostupy_map_url"
  end

  create_table "texts", force: true do |t|
    t.string   "name"
    t.text     "body_cs"
    t.text     "body_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "oris_registrations"
    t.string   "role"
    t.string   "authorized_clubs"
    t.string   "authorized_regions"
    t.string   "full_name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
