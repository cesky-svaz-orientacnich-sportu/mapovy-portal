# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_05_06_142603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgrouting"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_raster"
  enable_extension "postgis_topology"

  create_table "authorizations", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.integer "user_id"
    t.string "token", limit: 255
    t.string "secret", limit: 255
    t.string "name", limit: 255
    t.string "link", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "note", limit: 255
    t.string "full_name", limit: 255
    t.text "club"
    t.string "activity", limit: 255
    t.integer "year_of_birth"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "cartographers", id: :serial, force: :cascade do |t|
    t.integer "map_id"
    t.integer "author_id"
    t.string "role", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "clubs", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "abbreviation", limit: 255
    t.string "region", limit: 255
    t.string "district", limit: 255
    t.string "url", limit: 255
    t.string "division", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "oris_data_json"
    t.string "slug", limit: 255
    t.boolean "is_public", default: false
    t.index ["slug"], name: "index_clubs_on_slug", unique: true
  end

  create_table "issue_reports", id: :serial, force: :cascade do |t|
    t.integer "map_id"
    t.integer "user_id"
    t.string "email", limit: 255
    t.text "message"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "resolved", default: false, null: false
  end

  create_table "map_collection_memberships", id: :serial, force: :cascade do |t|
    t.integer "map_id"
    t.integer "map_collection_id"
    t.integer "year"
    t.string "note", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "map_collections", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "slug", limit: 255
    t.text "description"
    t.string "logo_file_name", limit: 255
    t.string "logo_content_type", limit: 255
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.index ["slug"], name: "index_map_collections_on_slug", unique: true
  end

  create_table "map_layers", id: :serial, force: :cascade do |t|
    t.integer "layer_index"
    t.string "title_cs", limit: 255
    t.string "title_en", limit: 255
    t.string "color", limit: 255
    t.boolean "visible_by_default"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "maps", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "patron", limit: 255
    t.string "patron_accuracy", limit: 255
    t.integer "year"
    t.string "year_accuracy", limit: 255
    t.integer "scale"
    t.string "archive_print1_class", limit: 255
    t.string "archive_print2_class", limit: 255
    t.string "archive_print3_class", limit: 255
    t.integer "archive_extra_print_count"
    t.float "equidistance"
    t.string "identifier_other", limit: 255
    t.string "locality", limit: 255
    t.float "area_size"
    t.string "issued_by", limit: 255
    t.string "printed_by", limit: 255
    t.string "map_type", limit: 255
    t.string "drawing_technique", limit: 255
    t.string "printing_technique", limit: 255
    t.string "resource", limit: 255
    t.string "main_race_title", limit: 255
    t.date "main_race_date"
    t.text "administrator"
    t.string "identifier_approval", limit: 255
    t.string "identifier_filing", limit: 255
    t.text "note_public"
    t.text "note_internal"
    t.string "preview_identifier", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "created_by_id"
    t.string "map_family", limit: 255
    t.string "map_sport", limit: 255
    t.integer "oris_event_id"
    t.text "shape_json"
    t.text "shape_kml"
    t.string "georeference", limit: 255
    t.string "region", limit: 255
    t.string "state", limit: 255
    t.text "record_log"
    t.integer "approved_by_id"
    t.string "mapping_state", limit: 255
    t.string "slug", limit: 255
    t.boolean "has_jpg", default: false, null: false
    t.boolean "has_kml", default: false, null: false
    t.string "administrator_email", limit: 255
    t.date "last_reminder_sent_at"
    t.date "state_changed_at"
    t.integer "completed_by_id"
    t.datetime "user_updated_at", precision: nil
    t.geometry "shape_geom", limit: {:srid=>0, :type=>"geometry"}
    t.string "cartographers_for_api", limit: 255
    t.string "color", limit: 255
    t.string "stroke_color", limit: 255
    t.boolean "has_embargo", default: false, null: false
    t.date "embargo_until"
    t.boolean "has_blocking", default: false, null: false
    t.integer "blocking_from"
    t.integer "blocking_until"
    t.boolean "has_competition_area", default: false, null: false
    t.date "competition_area_until"
    t.string "non_oris_event_url", limit: 255
    t.text "blocking_reason"
    t.boolean "is_educational", default: false, null: false
    t.index ["slug"], name: "index_maps_on_slug", unique: true
  end

  create_table "oris_events", id: :serial, force: :cascade do |t|
    t.integer "oris_id"
    t.date "date"
    t.string "title", limit: 255
    t.text "oris_json"
    t.string "place", limit: 255
    t.datetime "oris_timestamp", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "obpostupy_url", limit: 255
    t.string "obpostupy_map_url", limit: 255
  end

  create_table "texts", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "body_cs"
    t.text "body_en"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email", limit: 255
    t.string "oris_registrations", limit: 255
    t.string "role", limit: 255
    t.string "authorized_clubs", limit: 255
    t.string "authorized_regions", limit: 255
    t.string "full_name", limit: 255
    t.integer "above_role_authorizations", default: [], null: false, array: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
