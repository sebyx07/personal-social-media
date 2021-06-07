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

ActiveRecord::Schema.define(version: 2021_06_07_050125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "cache_reactions", force: :cascade do |t|
    t.string "character", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "peer_id", null: false
    t.bigint "remote_reaction_id", null: false
    t.index ["subject_type", "subject_id", "peer_id"], name: "idx_sub_type_sub_id_peer_id", unique: true
  end

  create_table "external_accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "service", null: false
    t.text "secret_key_ciphertext"
    t.text "public_key_ciphertext"
    t.text "username_ciphertext"
    t.text "password_ciphertext"
    t.text "email_ciphertext"
    t.text "secret_ciphertext"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "initializing", null: false
    t.string "usage", null: false
  end

  create_table "peers", force: :cascade do |t|
    t.binary "public_key", null: false
    t.binary "verify_key"
    t.string "domain_name", null: false
    t.string "name"
    t.bigint "status_mask", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email_hexdigest"
    t.string "nickname"
    t.boolean "is_me", default: false, null: false
    t.datetime "server_last_seen_at"
    t.datetime "last_seen_at"
    t.index ["public_key"], name: "index_peers_on_public_key"
    t.index ["status_mask"], name: "index_peers_on_status_mask"
    t.index ["verify_key"], name: "index_peers_on_verify_key"
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "pghero_space_stats", force: :cascade do |t|
    t.text "database"
    t.text "schema"
    t.text "relation"
    t.bigint "size"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_space_stats_on_database_and_captured_at"
  end

  create_table "posts", force: :cascade do |t|
    t.text "content"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "post_type", default: "standard", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.text "pk_ciphertext", null: false
    t.string "name", null: false
    t.string "nickname", null: false
    t.string "email", null: false
    t.string "password_plain"
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "sk_ciphertext", null: false
    t.string "backup_password_ciphertext", null: false
  end

  create_table "psm_cdn_files", force: :cascade do |t|
    t.text "url", null: false
    t.string "status", default: "pending", null: false
    t.bigint "size_bytes", default: 0, null: false
    t.bigint "psm_file_variant_id", null: false
    t.bigint "external_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "upload_percentage", default: 0, null: false
    t.string "external_file_name", null: false
    t.index ["external_account_id"], name: "index_psm_cdn_files_on_external_account_id"
    t.index ["psm_file_variant_id", "external_account_id"], name: "idx_psm_cdn_files_variant_to_external_account", unique: true
  end

  create_table "psm_file_permanents", force: :cascade do |t|
    t.integer "size_bytes", default: 0, null: false
    t.bigint "psm_file_variant_id", null: false
    t.bigint "external_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_account_id"], name: "index_psm_file_permanents_on_external_account_id"
    t.index ["psm_file_variant_id", "external_account_id"], name: "idx_psm_file_permanent_variant_to_external_account", unique: true
  end

  create_table "psm_file_variants", force: :cascade do |t|
    t.bigint "psm_file_id", null: false
    t.string "variant_name", null: false
    t.text "variant_metadata", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "permanent_storage_status", default: "pending", null: false
    t.string "cdn_storage_status", default: "pending", null: false
    t.index ["psm_file_id", "variant_name"], name: "index_psm_file_variants_on_psm_file_id_and_variant_name", unique: true
  end

  create_table "psm_files", force: :cascade do |t|
    t.string "name", null: false
    t.string "content_type", null: false
    t.jsonb "metadata", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "permanent_storage_status", default: "pending", null: false
    t.string "cdn_storage_status", default: "pending", null: false
    t.index ["metadata"], name: "index_psm_files_on_metadata", using: :gin
    t.index ["subject_type", "subject_id"], name: "index_psm_files_on_subject"
  end

  create_table "psm_permanent_files", force: :cascade do |t|
    t.bigint "size_bytes", default: 0, null: false
    t.string "status", default: "pending", null: false
    t.bigint "psm_file_variant_id", null: false
    t.bigint "external_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "archive_password_ciphertext", null: false
    t.integer "upload_percentage", default: 0, null: false
    t.string "external_file_name", null: false
    t.index ["external_account_id"], name: "index_psm_permanent_files_on_external_account_id"
    t.index ["psm_file_variant_id", "external_account_id"], name: "idx_psm_permanent_files_variant_to_external_account", unique: true
  end

  create_table "reaction_counters", force: :cascade do |t|
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.string "character", null: false
    t.bigint "reactions_count", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character"], name: "index_reaction_counters_on_character"
    t.index ["subject_type", "subject_id"], name: "index_reaction_counters_on_subject"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "reaction_counter_id", null: false
    t.bigint "peer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["peer_id"], name: "index_reactions_on_peer_id"
    t.index ["reaction_counter_id"], name: "index_reactions_on_reaction_counter_id"
  end

  create_table "remote_posts", force: :cascade do |t|
    t.bigint "remote_post_id", null: false
    t.bigint "peer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "post_type", default: "standard", null: false
    t.boolean "show_in_feed", default: false, null: false
    t.index ["peer_id"], name: "index_remote_posts_on_peer_id"
    t.index ["remote_post_id", "peer_id"], name: "index_remote_posts_on_remote_post_id_and_peer_id", unique: true
  end

  create_table "retry_requests", force: :cascade do |t|
    t.text "payload", default: "{}", null: false
    t.text "peer_ids", default: "[]", null: false
    t.string "url", null: false
    t.string "request_method", null: false
    t.integer "retries", default: 0, null: false
    t.integer "max_retries", default: 0, null: false
    t.string "request_type", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cache_reactions", "peers"
  add_foreign_key "psm_cdn_files", "external_accounts"
  add_foreign_key "psm_cdn_files", "psm_file_variants"
  add_foreign_key "psm_file_permanents", "external_accounts"
  add_foreign_key "psm_file_permanents", "psm_file_variants"
  add_foreign_key "psm_file_variants", "psm_files"
  add_foreign_key "psm_permanent_files", "external_accounts"
  add_foreign_key "psm_permanent_files", "psm_file_variants"
  add_foreign_key "reactions", "peers"
  add_foreign_key "reactions", "reaction_counters"
  add_foreign_key "remote_posts", "peers"
end
