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

ActiveRecord::Schema[7.0].define(version: 2024_07_19_195458) do
  create_table "authentications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "exercises", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", comment: "エクササイズ名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "subscriptions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "endpoint"
    t.string "auth_key"
    t.string "p256dh_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "crypted_password"
    t.string "salt"
    t.integer "gender", limit: 1, default: 0
    t.integer "only_same_gender_default", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workout_schedule_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "workout_schedule_id", comment: "ワークアウト予定ID"
    t.integer "exercise_id", comment: "エクササイズ ID"
    t.json "sets", comment: "重量とrep数を何秒休憩で何セットやったのかをJSONで保持"
    t.integer "one_rep_max_theoretical", comment: "selectしやすいように1set目の重量と回数から理論上の1rmをあらかじめ算出し別途保存"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workout_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", comment: "ユーザーID"
    t.string "googlemap_place_id", comment: "Google Mapsの場所ID"
    t.string "googlemap_place_name", comment: "Google Mapsの場所の名前"
    t.decimal "googlemap_place_lat", precision: 10, scale: 6, comment: "Google Mapsの場所の緯度"
    t.decimal "googlemap_place_lng", precision: 10, scale: 6, comment: "Google Mapsの場所の経度"
    t.datetime "start_at", comment: "ワークアウトの開始時間"
    t.datetime "finish_at", comment: "ワークアウトの終了時間"
    t.integer "do_leg", limit: 1, comment: "脚のエクササイズ 0:行わない 1:行う"
    t.integer "do_chest", limit: 1, comment: "胸のエクササイズ 0:行わない 1:行う"
    t.integer "do_back", limit: 1, comment: "背中のエクササイズ 0:行わない 1:行う"
    t.integer "do_arm", limit: 1, comment: "腕のエクササイズ 0:行わない 1:行う"
    t.integer "do_shoulder", limit: 1, comment: "肩のエクササイズ 0:行わない 1:行う"
    t.integer "only_same_gender", limit: 1, comment: "0: 性別を問わず検索される 1:同性のユーザーからのみ検索される"
    t.string "looks", comment: "当日の服装など"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notifications", "users"
  add_foreign_key "subscriptions", "users"
end
