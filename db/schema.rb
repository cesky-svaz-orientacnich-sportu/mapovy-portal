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

ActiveRecord::Schema.define(version: 20200127100043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.integer  "user_id"
    t.string   "token",      limit: 255
    t.string   "secret",     limit: 255
    t.string   "name",       limit: 255
    t.string   "link",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "note",          limit: 255
    t.string   "full_name",     limit: 255
    t.text     "club"
    t.string   "activity",      limit: 255
    t.integer  "year_of_birth"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "cartographers", force: :cascade do |t|
    t.integer  "map_id"
    t.integer  "author_id"
    t.string   "role",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "clubs", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "abbreviation",   limit: 255
    t.string   "region",         limit: 255
    t.string   "district",       limit: 255
    t.string   "url",            limit: 255
    t.string   "division",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "oris_data_json"
    t.string   "slug",           limit: 255
  end

  add_index "clubs", ["slug"], name: "index_clubs_on_slug", unique: true, using: :btree

  create_table "issue_reports", force: :cascade do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.string   "email",      limit: 255
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "resolved",               default: false, null: false
  end

  create_table "map_collection_memberships", force: :cascade do |t|
    t.integer  "map_id"
    t.integer  "map_collection_id"
    t.integer  "year"
    t.string   "note",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "map_collections", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "slug",              limit: 255
    t.text     "description"
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "map_collections", ["slug"], name: "index_map_collections_on_slug", unique: true, using: :btree

  create_table "map_layers", force: :cascade do |t|
    t.integer  "layer_index"
    t.string   "title_cs",           limit: 255
    t.string   "title_en",           limit: 255
    t.string   "color",              limit: 255
    t.boolean  "visible_by_default"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "maps", force: :cascade do |t|
    t.string   "title",                     limit: 255
    t.string   "patron",                    limit: 255
    t.string   "patron_accuracy",           limit: 255
    t.integer  "year"
    t.string   "year_accuracy",             limit: 255
    t.integer  "scale"
    t.string   "archive_print1_class",      limit: 255
    t.string   "archive_print2_class",      limit: 255
    t.string   "archive_print3_class",      limit: 255
    t.integer  "archive_extra_print_count"
    t.float    "equidistance"
    t.string   "identifier_other",          limit: 255
    t.string   "locality",                  limit: 255
    t.float    "area_size"
    t.string   "issued_by",                 limit: 255
    t.string   "printed_by",                limit: 255
    t.string   "map_type",                  limit: 255
    t.string   "drawing_technique",         limit: 255
    t.string   "printing_technique",        limit: 255
    t.string   "resource",                  limit: 255
    t.string   "main_race_title",           limit: 255
    t.date     "main_race_date"
    t.text     "administrator"
    t.string   "identifier_approval",       limit: 255
    t.string   "identifier_filing",         limit: 255
    t.text     "note_public"
    t.text     "note_internal"
    t.string   "preview_identifier",        limit: 255
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
    t.integer  "created_by_id"
    t.string   "map_family",                limit: 255
    t.string   "map_sport",                 limit: 255
    t.integer  "oris_event_id"
    t.text     "shape_json"
    t.text     "shape_kml"
    t.string   "georeference",              limit: 255
    t.string   "region",                    limit: 255
    t.string   "state",                     limit: 255
    t.text     "record_log"
    t.integer  "approved_by_id"
    t.string   "mapping_state",             limit: 255
    t.string   "slug",                      limit: 255
    t.boolean  "has_jpg",                                                         default: false, null: false
    t.boolean  "has_kml",                                                         default: false, null: false
    t.string   "administrator_email",       limit: 255
    t.date     "last_reminder_sent_at"
    t.date     "state_changed_at"
    t.integer  "completed_by_id"
    t.datetime "user_updated_at"
    t.geometry "shape_geom",                limit: {:srid=>0, :type=>"geometry"}
    t.string   "cartographers_for_api",     limit: 255
    t.string   "color",                     limit: 255
    t.string   "stroke_color",              limit: 255
    t.boolean  "has_embargo",                                                     default: false, null: false
    t.date     "embargo_until"
    t.boolean  "has_blocking",                                                    default: false, null: false
    t.integer  "blocking_from"
    t.integer  "blocking_until"
    t.boolean  "has_competition_area",                                            default: false, null: false
    t.date     "competition_area_until"
  end

  add_index "maps", ["slug"], name: "index_maps_on_slug", unique: true, using: :btree

  create_table "oris_events", force: :cascade do |t|
    t.integer  "oris_id"
    t.date     "date"
    t.string   "title",             limit: 255
    t.text     "oris_json"
    t.string   "place",             limit: 255
    t.datetime "oris_timestamp"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "obpostupy_url",     limit: 255
    t.string   "obpostupy_map_url", limit: 255
  end

  create_table "texts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "body_cs"
    t.text     "body_en"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "oris_registrations",     limit: 255
    t.string   "role",                   limit: 255
    t.string   "authorized_clubs",       limit: 255
    t.string   "authorized_regions",     limit: 255
    t.string   "full_name",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
