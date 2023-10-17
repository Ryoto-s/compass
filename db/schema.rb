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

ActiveRecord::Schema[7.1].define(version: 2023_10_14_113523) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "results", force: :cascade do |t|
    t.bigint "word_book_master_id", null: false
    t.datetime "learned_at", null: false
    t.boolean "result", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learned_at"], name: "index_results_on_learned_at"
    t.index ["word_book_master_id"], name: "index_results_on_word_book_master_id"
  end

  create_table "tag_references", force: :cascade do |t|
    t.bigint "word_book_master_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tag_references_on_tag_id"
    t.index ["word_book_master_id"], name: "index_tag_references_on_word_book_master_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "first_name", null: false
    t.string "sur_name", null: false
    t.string "first_phonetic"
    t.string "sur_phonetic"
    t.date "date_of_birth", null: false
    t.string "sex"
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["first_phonetic"], name: "index_users_on_first_phonetic"
    t.index ["sur_name"], name: "index_users_on_sur_name"
    t.index ["sur_phonetic"], name: "index_users_on_sur_phonetic"
  end

  create_table "word_book_masters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "use_image", null: false
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_word_book_masters_on_user_id"
  end

  create_table "word_definitions", force: :cascade do |t|
    t.bigint "word_book_master_id", null: false
    t.string "word", null: false
    t.text "answer", null: false
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word"], name: "index_word_definitions_on_word"
    t.index ["word_book_master_id"], name: "index_word_definitions_on_word_book_master_id"
  end

  create_table "word_images", force: :cascade do |t|
    t.bigint "word_book_master_id", null: false
    t.text "image_path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word_book_master_id"], name: "index_word_images_on_word_book_master_id"
  end

  add_foreign_key "results", "word_book_masters"
  add_foreign_key "tag_references", "tags"
  add_foreign_key "tag_references", "word_book_masters"
  add_foreign_key "users", "accounts"
  add_foreign_key "word_book_masters", "users"
  add_foreign_key "word_definitions", "word_book_masters"
  add_foreign_key "word_images", "word_book_masters"
end
