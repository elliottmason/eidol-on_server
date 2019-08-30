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

ActiveRecord::Schema.define(version: 2019_08_29_011803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_positions", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_board_positions_on_board_id"
  end

  create_table "board_positions_combatants_players_matches", force: :cascade do |t|
    t.bigint "board_position_id", null: false
    t.bigint "combatants_players_match_id", null: false
    t.bigint "match_turn_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_position_id"], name: "idx_board_positions_combatants_players_matches_board_position"
    t.index ["combatants_players_match_id"], name: "idx_brd_pstns_cmbtnts_plyrs_mtchs_combatants_players_match"
    t.index ["match_turn_id"], name: "index_board_positions_combatants_players_matches_match_turn_id"
  end

  create_table "board_positions_match_turns", force: :cascade do |t|
    t.bigint "board_position_id", null: false
    t.bigint "match_turn_id", null: false
    t.string "availability", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_position_id"], name: "index_board_positions_match_turns_on_board_position_id"
    t.index ["match_turn_id"], name: "index_board_positions_match_turns_on_match_turn_id"
  end

  create_table "boards", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "combatants", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "combatants_players", force: :cascade do |t|
    t.bigint "combatant_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatant_id"], name: "index_combatants_players_on_combatant_id"
    t.index ["player_id"], name: "index_combatants_players_on_player_id"
  end

  create_table "combatants_players_matches", force: :cascade do |t|
    t.bigint "combatants_player_id", null: false
    t.bigint "match_id"
    t.integer "defense", null: false
    t.integer "health", null: false
    t.integer "level", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatants_player_id"], name: "index_combatants_players_matches_on_combatants_player_id"
    t.index ["match_id"], name: "index_combatants_players_matches_on_match_id"
  end

  create_table "combatants_players_matches_match_turns", force: :cascade do |t|
    t.bigint "combatants_players_match_id", null: false
    t.bigint "match_event_id", null: false
    t.bigint "match_turn_id", null: false
    t.integer "level", null: false
    t.integer "remaining_health", null: false
    t.integer "defense", null: false
    t.string "availability", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatants_players_match_id"], name: "idx_cmbtnts_plyrs_mtchs_match_turns_combatants_players_match"
    t.index ["match_event_id"], name: "index_combatants_players_matches_match_turns_on_match_event_id"
    t.index ["match_turn_id"], name: "index_combatants_players_matches_match_turns_on_match_turn_id"
  end

  create_table "combatants_players_matches_move_selections", force: :cascade do |t|
    t.bigint "board_position_id"
    t.bigint "combatants_players_matches_move_id", null: false
    t.bigint "match_turn_id", null: false
    t.datetime "processed_at"
    t.boolean "was_successful"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_position_id"], name: "index_combatants_players_matches_move_selections_board_position"
    t.index ["combatants_players_matches_move_id"], name: "idx_cmbtnts_plyrs_mtchs_mv_slctns_cmbtnts_plyrs_mtchs_mv"
    t.index ["match_turn_id"], name: "index_combatants_players_matches_move_selections_match_turn"
  end

  create_table "combatants_players_matches_moves", force: :cascade do |t|
    t.bigint "combatants_players_match_id", null: false
    t.bigint "move_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatants_players_match_id"], name: "idx_combatants_players_matches_moves_combatants_players_match"
    t.index ["move_id"], name: "index_combatants_players_matches_moves_on_move_id"
  end

  create_table "combatants_players_moves", force: :cascade do |t|
    t.bigint "combatants_player_id", null: false
    t.bigint "move_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatants_player_id"], name: "index_combatants_players_moves_on_combatants_player_id"
    t.index ["move_id"], name: "index_combatants_players_moves_on_move_id"
  end

  create_table "match_turns", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.integer "turn", null: false
    t.datetime "processed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_match_turns_on_match_id"
  end

  create_table "match_turns_move_turns", force: :cascade do |t|
    t.bigint "combatants_players_match_id", null: false
    t.bigint "match_turn_id", null: false
    t.bigint "move_turn_id", null: false
    t.datetime "processed_at"
    t.boolean "was_successful"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["combatants_players_match_id"], name: "index_match_turns_move_turns_on_combatants_players_match_id"
    t.index ["match_turn_id"], name: "index_match_turns_move_turns_on_match_turn_id"
    t.index ["move_turn_id"], name: "index_match_turns_move_turns_on_move_turn_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_matches_on_board_id"
  end

  create_table "matches_players", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_matches_players_on_match_id"
    t.index ["player_id"], name: "index_matches_players_on_player_id"
  end

  create_table "move_turn_effects", force: :cascade do |t|
    t.bigint "move_turn_id", null: false
    t.string "effect_type", null: false
    t.string "property"
    t.integer "power", default: 0, null: false
    t.integer "precedence", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["move_turn_id"], name: "index_move_turn_effects_on_move_turn_id"
  end

  create_table "move_turns", force: :cascade do |t|
    t.bigint "move_id", null: false
    t.integer "turn", null: false
    t.integer "speed", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["move_id"], name: "index_move_turns_on_move_id"
  end

  create_table "moves", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.integer "energy_cost", null: false
    t.integer "range", null: false
    t.boolean "is_diagonal", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
