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

ActiveRecord::Schema.define(version: 2021_07_19_212008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "cache_comments", force: :cascade do |t|
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.bigint "peer_id", null: false
    t.bigint "remote_comment_id", null: false
    t.string "comment_type", null: false
    t.jsonb "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "remote_parent_comment_id"
    t.index ["peer_id"], name: "index_cache_comments_on_peer_id"
    t.index ["subject_type", "subject_id"], name: "index_cache_comments_on_subject"
  end

  create_table "cache_reactions", force: :cascade do |t|
    t.string "character", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "peer_id", null: false
    t.bigint "remote_reaction_id", null: false
    t.index ["character", "subject_type", "subject_id", "peer_id"], name: "idx_sub_type_sub_id_peer_id"
  end

  create_table "cdn_storage_providers", force: :cascade do |t|
    t.string "adapter", null: false
    t.boolean "enabled", default: false, null: false
    t.string "free_space_bytes", default: "0", null: false
    t.string "used_space_bytes", default: "0", null: false
    t.bigint "external_account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_account_id"], name: "index_cdn_storage_providers_on_external_account_id"
  end

  create_table "comment_counters", force: :cascade do |t|
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.bigint "comments_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_type", "subject_id"], name: "index_comment_counters_on_subject"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "comment_counter_id", null: false
    t.bigint "parent_comment_id"
    t.bigint "peer_id", null: false
    t.string "comment_type", default: "standard", null: false
    t.jsonb "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sub_comments_count", default: 0, null: false
    t.boolean "is_latest", null: false
    t.binary "signature", null: false
    t.index ["comment_counter_id"], name: "index_comments_on_comment_counter_id"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["peer_id"], name: "index_comments_on_peer_id"
  end

  create_table "conversation_messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "peer_id", null: false
    t.jsonb "content", null: false
    t.string "conversation_message_type", null: false
    t.boolean "seen", null: false
    t.bigint "remote_conversation_message_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_conversation_messages_on_conversation_id"
    t.index ["peer_id"], name: "index_conversation_messages_on_peer_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "peer_id", null: false
    t.boolean "is_focused", default: false, null: false
    t.bigint "unread_messages_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["peer_id"], name: "index_conversations_on_peer_id"
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

  create_table "notifications", force: :cascade do |t|
    t.bigint "peer_id", null: false
    t.string "type", null: false
    t.jsonb "content", default: "{}", null: false
    t.boolean "seen", default: false, null: false
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["peer_id"], name: "index_notifications_on_peer_id"
    t.index ["subject_type", "subject_id"], name: "index_notifications_on_subject"
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

  create_table "permanent_storage_providers", force: :cascade do |t|
    t.bigint "external_account_id"
    t.string "adapter", null: false
    t.string "used_space_bytes", default: "0", null: false
    t.string "free_space_bytes", default: "0", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_account_id"], name: "index_permanent_storage_providers_on_external_account_id"
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
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "post_type", default: "standard", null: false
    t.bigint "views", default: 0, null: false
    t.binary "signature", null: false
    t.jsonb "content", null: false
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
    t.string "status", default: "pending", null: false
    t.bigint "psm_file_variant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "upload_percentage", default: 0, null: false
    t.bigint "cdn_storage_provider_id", null: false
    t.text "cache_url"
    t.index ["cdn_storage_provider_id"], name: "index_psm_cdn_files_on_cdn_storage_provider_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "permanent_storage_status", default: "pending", null: false
    t.string "cdn_storage_status", default: "pending", null: false
    t.string "key_ciphertext", null: false
    t.string "iv_ciphertext", null: false
    t.bigint "size_bytes", default: 0, null: false
    t.string "external_file_name", null: false
    t.jsonb "variant_metadata", default: "{}", null: false
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
    t.string "sha_256", limit: 64, null: false
    t.index ["metadata"], name: "index_psm_files_on_metadata", using: :gin
    t.index ["subject_type", "subject_id"], name: "index_psm_files_on_subject"
  end

  create_table "psm_permanent_files", force: :cascade do |t|
    t.bigint "size_bytes", default: 0, null: false
    t.string "status", default: "pending", null: false
    t.bigint "psm_file_variant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "archive_password_ciphertext", null: false
    t.integer "upload_percentage", default: 0, null: false
    t.string "external_file_name", null: false
    t.bigint "permanent_storage_provider_id", null: false
    t.index ["permanent_storage_provider_id"], name: "index_psm_permanent_files_on_permanent_storage_provider_id"
  end

  create_table "rails_server_monitor_server_groups", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "rails_server_monitor_servers", default: 0, null: false
    t.index ["name"], name: "index_rails_server_monitor_server_groups_on_name", unique: true
  end

  create_table "rails_server_monitor_server_snapshots", force: :cascade do |t|
    t.float "cpu_usage_percentage"
    t.float "ram_usage_percentage"
    t.float "hdd_usage_percentage"
    t.text "ram_stats"
    t.text "hdd_stats"
    t.text "network_stats"
    t.bigint "rails_server_monitor_server_id", null: false
    t.datetime "created_at"
    t.index ["created_at"], name: "index_rails_server_monitor_server_snapshots_on_created_at"
    t.index ["rails_server_monitor_server_id"], name: "rails_server_monitor_snapshots_on_server"
  end

  create_table "rails_server_monitor_servers", force: :cascade do |t|
    t.string "hostname"
    t.datetime "last_seen_at"
    t.string "custom_name"
    t.text "custom_description"
    t.text "system_information"
    t.bigint "rails_server_monitor_server_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hostname"], name: "index_rails_server_monitor_servers_on_hostname"
    t.index ["rails_server_monitor_server_group_id"], name: "rails_server_monitor_server_on_group"
  end

  create_table "reaction_counters", force: :cascade do |t|
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.string "character", null: false
    t.bigint "reactions_count", default: 0, null: false
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

  create_table "upload_files", force: :cascade do |t|
    t.bigint "upload_id", null: false
    t.string "file_name"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["file_name"], name: "index_upload_files_on_file_name"
    t.index ["upload_id"], name: "index_upload_files_on_upload_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.string "status", default: "pending", null: false
    t.string "resumable_upload_identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_type", "subject_id"], name: "index_uploads_on_subject"
  end

  add_foreign_key "cache_comments", "peers"
  add_foreign_key "cache_reactions", "peers"
  add_foreign_key "cdn_storage_providers", "external_accounts"
  add_foreign_key "comments", "comment_counters"
  add_foreign_key "comments", "comments", column: "parent_comment_id"
  add_foreign_key "comments", "peers"
  add_foreign_key "conversation_messages", "conversations"
  add_foreign_key "conversation_messages", "peers"
  add_foreign_key "conversations", "peers"
  add_foreign_key "notifications", "peers"
  add_foreign_key "permanent_storage_providers", "external_accounts"
  add_foreign_key "psm_cdn_files", "cdn_storage_providers"
  add_foreign_key "psm_cdn_files", "psm_file_variants"
  add_foreign_key "psm_file_permanents", "external_accounts"
  add_foreign_key "psm_file_permanents", "psm_file_variants"
  add_foreign_key "psm_file_variants", "psm_files"
  add_foreign_key "psm_permanent_files", "permanent_storage_providers"
  add_foreign_key "psm_permanent_files", "psm_file_variants"
  add_foreign_key "rails_server_monitor_server_snapshots", "rails_server_monitor_servers"
  add_foreign_key "rails_server_monitor_servers", "rails_server_monitor_server_groups"
  add_foreign_key "reactions", "peers"
  add_foreign_key "reactions", "reaction_counters"
  add_foreign_key "remote_posts", "peers"
  add_foreign_key "upload_files", "uploads"
end
