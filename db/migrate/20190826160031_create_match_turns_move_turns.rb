class CreateMatchTurnsMoveTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :match_turns_move_turns do |t|
      t.belongs_to :combatants_players_matches_move_selection, null: false
      t.belongs_to :match_turn, null: false
      t.belongs_to :move_turn, null: false
      t.datetime :processed_at
      t.boolean :was_successful
      t.timestamps
    end
  end
end
