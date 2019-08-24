# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_24_043918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "combatants_players", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "combatants_players_matches", force: :cascade do |t|
    t.bigint "combatants_player_id"
    t.bigint "match_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatants_player_id"], name: "index_combatants_players_matches_on_combatants_player_id"
    t.index ["match_id"], name: "index_combatants_players_matches_on_match_id"
  end

  create_table "combatants_players_matches_move_selections", force: :cascade do |t|
    t.bigint "combatants_players_matches_move_id"
    t.bigint "match_turn_id"
    t.datetime "processed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "combatants_players_matches_moves", force: :cascade do |t|
    t.bigint "combatants_players_match_id"
    t.bigint "move_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["move_id"], name: "index_combatants_players_matches_moves_on_move_id"
  end

  create_table "match_turns", force: :cascade do |t|
    t.bigint "match_id"
    t.integer "turn", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_match_turns_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
