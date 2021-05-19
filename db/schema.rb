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

ActiveRecord::Schema.define(version: 2021_05_19_035711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.boolean "is_me"
    t.index ["public_key"], name: "index_peers_on_public_key"
    t.index ["status_mask"], name: "index_peers_on_status_mask"
    t.index ["verify_key"], name: "index_peers_on_verify_key"
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
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
