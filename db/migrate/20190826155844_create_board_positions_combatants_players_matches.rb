class CreateBoardPositionsCombatantsPlayersMatches < ActiveRecord::Migration[6.0]
  def change
    create_join_table :board_positions, :combatants_players_matches do |t|
      t.belongs_to :match_turn,
                   null: false,
                   index: { name: 'index_board_positions_combatants_players_matches_match_turn_id' }
      t.timestamps
    end
  end
end
