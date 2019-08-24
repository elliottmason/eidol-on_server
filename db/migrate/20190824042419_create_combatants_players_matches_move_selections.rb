class CreateCombatantsPlayersMatchesMoveSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_move_selections do |t|
      t.belongs_to :combatants_players_matches_move, index: false
      t.belongs_to :match_turn, index: false
      t.datetime :processed_at, null: true
      t.timestamps
    end
  end
end
