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

ActiveRecord::Schema[8.1].define(version: 2026_11_04_213022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_analytics_browsers_per_days", force: :cascade do |t|
    t.string "site", null: false
    t.string "name", null: false
    t.string "version", null: false
    t.date "date", null: false
    t.bigint "total", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "site", "name", "version"], name: "idx_on_date_site_name_version_eeccd0371c"
  end

  create_table "active_analytics_views_per_days", force: :cascade do |t|
    t.string "site", null: false
    t.string "page", null: false
    t.date "date", null: false
    t.bigint "total", default: 1, null: false
    t.string "referrer_host"
    t.string "referrer_path"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["date"], name: "index_active_analytics_views_per_days_on_date"
    t.index ["referrer_host", "referrer_path", "date"], name: "index_active_analytics_views_per_days_on_referrer_and_date"
    t.index ["site", "page", "date"], name: "index_active_analytics_views_per_days_on_site_and_date"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "calculators", force: :cascade do |t|
    t.bigint "user_id"
    t.float "distance", null: false
    t.float "floor_down", null: false
    t.float "floor_down_elevator", null: false
    t.float "floor_up", null: false
    t.float "floor_up_elevator", null: false
    t.index ["user_id"], name: "index_calculators_on_user_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "ru", null: false
    t.string "uk", null: false
    t.string "en", null: false
    t.string "he", null: false
    t.string "category"
  end

  create_table "cities", force: :cascade do |t|
    t.string "ru", null: false
    t.string "en", null: false
    t.string "uk", null: false
    t.string "he", null: false
    t.bigint "district_id", null: false
    t.index ["district_id"], name: "index_cities_on_district_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.string "object_type", null: false
    t.bigint "object_id", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["object_type", "object_id"], name: "index_comments_on_object"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "districts", force: :cascade do |t|
    t.string "ru", null: false
    t.string "uk", null: false
    t.string "en", null: false
    t.string "he", null: false
  end

  create_table "districts_users", id: false, force: :cascade do |t|
    t.bigint "district_id"
    t.bigint "user_id"
    t.index ["district_id"], name: "index_districts_users_on_district_id"
    t.index ["user_id"], name: "index_districts_users_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "favorited_type", null: false
    t.bigint "favorited_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favorited_type", "favorited_id"], name: "index_favorites_on_favorited"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.float "usability", default: 0.0, null: false
    t.float "speed", default: 0.0, null: false
    t.float "design", default: 0.0, null: false
    t.float "quality", default: 0.0, null: false
    t.boolean "informative", null: false
    t.boolean "problems", null: false
    t.string "title"
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable"
  end

  create_table "languages", force: :cascade do |t|
    t.string "title", null: false
  end

  create_table "languages_users", id: false, force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "user_id"
    t.index ["language_id"], name: "index_languages_users_on_language_id"
    t.index ["user_id"], name: "index_languages_users_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.text "content"
    t.boolean "readed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "news", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.boolean "published", default: true, null: false
    t.integer "views", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "prices", force: :cascade do |t|
    t.bigint "thing_id", null: false
    t.bigint "user_id", null: false
    t.float "amount", null: false
    t.index ["thing_id"], name: "index_prices_on_thing_id"
    t.index ["user_id"], name: "index_prices_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.bigint "thing_id", null: false
    t.bigint "district_id", null: false
    t.bigint "city_id", null: false
    t.string "title", null: false
    t.string "description"
    t.integer "condition", null: false
    t.integer "delivery", null: false
    t.integer "price", null: false
    t.integer "views", default: 0, null: false
    t.boolean "published", default: true, null: false
    t.boolean "sold", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["city_id"], name: "index_products_on_city_id"
    t.index ["district_id"], name: "index_products_on_district_id"
    t.index ["thing_id"], name: "index_products_on_thing_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", default: 0, null: false
    t.integer "price", default: 0, null: false
    t.string "title"
    t.text "content"
    t.bigint "user_id", null: false
    t.string "reviewable_type", null: false
    t.bigint "reviewable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms_users", id: false, force: :cascade do |t|
    t.bigint "room_id"
    t.bigint "user_id"
    t.index ["room_id"], name: "index_rooms_users_on_room_id"
    t.index ["user_id"], name: "index_rooms_users_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "ru", null: false
    t.string "uk", null: false
    t.string "en", null: false
    t.string "he", null: false
  end

  create_table "services_users", id: false, force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "user_id"
    t.index ["service_id"], name: "index_services_users_on_service_id"
    t.index ["user_id"], name: "index_services_users_on_user_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
  end

  create_table "things", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "ru", null: false
    t.string "uk", null: false
    t.string "en", null: false
    t.string "he", null: false
    t.index ["category_id"], name: "index_things_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "phone"
    t.string "type"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "avatar"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.date "birthday"
    t.string "title"
    t.string "website"
    t.string "facebook"
    t.string "description"
    t.string "additional_phone"
    t.string "whatsapp"
    t.string "telegram"
    t.integer "views", default: 0, null: false
    t.float "rating", default: 0.0, null: false
    t.float "price", default: 0.0, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.string "locale", default: "en", null: false
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "calculators", "users"
  add_foreign_key "cities", "districts"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "news", "users"
  add_foreign_key "prices", "things"
  add_foreign_key "prices", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "cities"
  add_foreign_key "products", "districts"
  add_foreign_key "products", "things"
  add_foreign_key "products", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "things", "categories"
  add_foreign_key "users", "cities"
end
