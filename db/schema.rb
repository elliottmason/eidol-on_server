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

ActiveRecord::Schema.define(version: 2019_11_11_062002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_combatant_statuses", force: :cascade do |t|
    t.bigint "account_combatant_id", null: false
    t.integer "exp", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_combatant_id"], name: "index_account_combatant_statuses_on_account_combatant_id"
  end

  create_table "account_combatants", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "combatant_id", null: false
    t.integer "individual_defense", null: false
    t.integer "individual_health", null: false
    t.integer "individual_power", null: false
    t.integer "individual_speed", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_account_combatants_on_account_id"
    t.index ["combatant_id"], name: "index_account_combatants_on_combatant_id"
  end

  create_table "account_combatants_moves", force: :cascade do |t|
    t.bigint "account_combatant_id", null: false
    t.bigint "move_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_combatant_id"], name: "index_account_combatants_moves_on_account_combatant_id"
    t.index ["move_id"], name: "index_account_combatants_moves_on_move_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "username", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email_address"], name: "index_accounts_on_email_address", unique: true
  end

  create_table "board_positions", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_board_positions_on_match_id"
  end

  create_table "combatants", force: :cascade do |t|
    t.string "name", null: false
    t.integer "base_defense", null: false
    t.integer "base_health", null: false
    t.integer "base_agility", null: false
    t.integer "maximum_energy", null: false
    t.integer "initial_remaining_energy", null: false
    t.integer "energy_per_turn", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "match_combatant_statuses", force: :cascade do |t|
    t.bigint "board_position_id"
    t.bigint "match_combatant_id", null: false
    t.bigint "match_event_id"
    t.integer "remaining_energy", null: false
    t.integer "remaining_health", null: false
    t.string "availability", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_position_id"], name: "index_match_combatant_statuses_on_board_position_id"
    t.index ["match_combatant_id"], name: "index_match_combatant_statuses_on_match_combatant_id"
    t.index ["match_event_id"], name: "index_match_combatant_statuses_on_match_event_id"
  end

  create_table "match_combatants", force: :cascade do |t|
    t.bigint "account_combatant_id", null: false
    t.bigint "player_id", null: false
    t.integer "defense", null: false
    t.integer "level", null: false
    t.integer "maximum_energy", null: false
    t.integer "maximum_health", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_combatant_id"], name: "index_match_combatants_on_account_combatant_id"
    t.index ["player_id"], name: "index_match_combatants_on_player_id"
  end

  create_table "match_combatants_moves", force: :cascade do |t|
    t.bigint "match_combatant_id", null: false
    t.bigint "move_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_combatant_id"], name: "index_match_combatants_moves_on_match_combatant_id"
    t.index ["move_id"], name: "index_match_combatants_moves_on_move_id"
  end

  create_table "match_events", force: :cascade do |t|
    t.bigint "board_position_id"
    t.bigint "match_combatant_id", null: false
    t.bigint "match_move_turn_id", null: false
    t.bigint "move_turn_effect_id", null: false
    t.string "category", null: false
    t.string "property", null: false
    t.integer "amount"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_position_id"], name: "index_match_events_on_board_position_id"
    t.index ["match_combatant_id"], name: "index_match_events_on_match_combatant_id"
    t.index ["match_move_turn_id"], name: "index_match_events_on_match_move_turn_id"
    t.index ["move_turn_effect_id"], name: "index_match_events_on_move_turn_effect_id"
  end

  create_table "match_move_selections", force: :cascade do |t|
    t.bigint "board_position_id"
    t.bigint "match_combatants_move_id", null: false
    t.bigint "match_turn_id", null: false
    t.bigint "player_id"
    t.boolean "was_system_selected", default: false, null: false
    t.datetime "processed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_position_id"], name: "index_match_move_selections_on_board_position_id"
    t.index ["match_combatants_move_id"], name: "index_match_move_selections_on_match_combatants_move_id"
    t.index ["match_turn_id"], name: "index_match_move_selections_on_match_turn_id"
    t.index ["player_id"], name: "index_match_move_selections_on_player_id"
  end

  create_table "match_move_turns", force: :cascade do |t|
    t.bigint "match_combatant_id", null: false
    t.bigint "match_move_selection_id"
    t.bigint "match_turn_id", null: false
    t.bigint "move_turn_id", null: false
    t.datetime "processed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_combatant_id"], name: "index_match_move_turns_on_match_combatant_id"
    t.index ["match_move_selection_id"], name: "index_match_move_turns_on_match_move_selection_id"
    t.index ["match_turn_id"], name: "index_match_move_turns_on_match_turn_id"
    t.index ["move_turn_id"], name: "index_match_move_turns_on_move_turn_id"
  end

  create_table "match_turns", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.integer "turn", null: false
    t.datetime "processed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_match_turns_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "ended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "move_turn_effects", force: :cascade do |t|
    t.bigint "move_turn_id", null: false
    t.string "category", null: false
    t.string "property", null: false
    t.integer "power", default: 0, null: false
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

  create_table "player_statuses", force: :cascade do |t|
    t.bigint "match_turn_id", null: false
    t.bigint "player_id", null: false
    t.string "availability", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_turn_id"], name: "index_player_statuses_on_match_turn_id"
    t.index ["player_id"], name: "index_player_statuses_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "match_id", null: false
    t.string "name", null: false
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_players_on_account_id"
    t.index ["match_id"], name: "index_players_on_match_id"
  end

end
