class CreateBoardPositionsCombatantsPlayersMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :board_positions_combatants_players_matches do |t|
      t.belongs_to :board_position,
                   null: false,
                   index: { name: 'idx_board_positions_combatants_players_matches_board_position' }
      t.belongs_to :combatants_players_match,
                   null: false,
                   index: { name: 'idx_brd_pstns_cmbtnts_plyrs_mtchs_combatants_players_match' }
      t.belongs_to :match_turn,
                   null: false,
                   index: { name: 'index_board_positions_combatants_players_matches_match_turn_id' }
      t.timestamps
    end
  end
end
