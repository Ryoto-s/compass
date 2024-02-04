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

ActiveRecord::Schema[7.1].define(version: 2024_01_31_145900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favourites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "flashcard_master_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_master_id"], name: "index_favourites_on_flashcard_master_id"
    t.index ["user_id", "flashcard_master_id"], name: "index_favourites_on_user_id_and_flashcard_master_id", unique: true
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "flashcard_definitions", force: :cascade do |t|
    t.bigint "flashcard_master_id", null: false
    t.string "word", null: false
    t.text "answer", null: false
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_master_id"], name: "index_flashcard_definitions_on_flashcard_master_id", unique: true
    t.index ["word"], name: "index_flashcard_definitions_on_word"
  end

  create_table "flashcard_images", force: :cascade do |t|
    t.bigint "flashcard_master_id", null: false
    t.text "image", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_master_id"], name: "index_flashcard_images_on_flashcard_master_id", unique: true
  end

  create_table "flashcard_masters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "use_image", null: false
    t.boolean "input_enabled", null: false
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shared_flag", default: 0, null: false
    t.index ["user_id"], name: "index_flashcard_masters_on_user_id"
  end

  create_table "registration_tokens", force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_registration_tokens_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "flashcard_master_id", null: false
    t.bigint "user_id", null: false
    t.datetime "learned_at", null: false
    t.integer "result", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_master_id", "learned_at"], name: "index_results_on_flashcard_master_id_and_learned_at", unique: true
    t.index ["flashcard_master_id"], name: "index_results_on_flashcard_master_id"
    t.index ["learned_at"], name: "index_results_on_learned_at"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "tag_references", force: :cascade do |t|
    t.bigint "flashcard_master_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flashcard_master_id", "tag_id"], name: "index_tag_references_on_flashcard_master_id_and_tag_id", unique: true
    t.index ["flashcard_master_id"], name: "index_tag_references_on_flashcard_master_id"
    t.index ["tag_id"], name: "index_tag_references_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "user_defs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", null: false
    t.string "sur_name", null: false
    t.string "first_phonetic"
    t.string "sur_phonetic"
    t.date "date_of_birth", null: false
    t.string "sex"
    t.boolean "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_user_defs_on_first_name"
    t.index ["first_phonetic"], name: "index_user_defs_on_first_phonetic"
    t.index ["sur_name"], name: "index_user_defs_on_sur_name"
    t.index ["sur_phonetic"], name: "index_user_defs_on_sur_phonetic"
    t.index ["user_id", "status"], name: "index_user_defs_on_user_id_and_status", unique: true
    t.index ["user_id"], name: "index_user_defs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.datetime "confirmed_at"
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favourites", "flashcard_masters"
  add_foreign_key "favourites", "users"
  add_foreign_key "flashcard_definitions", "flashcard_masters"
  add_foreign_key "flashcard_images", "flashcard_masters"
  add_foreign_key "flashcard_masters", "users"
  add_foreign_key "registration_tokens", "users"
  add_foreign_key "results", "flashcard_masters"
  add_foreign_key "results", "users"
  add_foreign_key "tag_references", "flashcard_masters"
  add_foreign_key "tag_references", "tags"
  add_foreign_key "tags", "users"
  add_foreign_key "user_defs", "users"
end
