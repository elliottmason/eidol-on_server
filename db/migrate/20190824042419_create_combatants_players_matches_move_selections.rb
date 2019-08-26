class CreateCombatantsPlayersMatchesMoveSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_move_selections do |t|
      t.belongs_to :board_position,
                   null: false,
                   index: { name: "index_move_selections_on_board_position_id"}
      t.belongs_to :combatants_players_matches_move,
                   null: false,
                   index: { name: 'index_move_selections_on_combatants_players_matches_move_id' }
      t.belongs_to :match_turn,
                   null: false,
                   index: { name: 'index_move_selections_on_match_turn_id' }
      t.datetime :processed_at
      t.timestamps
    end
  end
end
