class CreateCombatantsPlayersMatchesMovesMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_moves_match_turns do |t|
      t.belongs_to :board_position,
                   index: { name: 'idx_cmbtnts_plyrs_mtchs_mvs_mtch_trns_board_position' }
      t.belongs_to :combatants_players_matches_move,
                   null: false,
                   index: { name: 'idx_cmbtnts_plyrs_mtchs_mvs_mtch_trns_cmbtnts_plyrs_mtchs_mv' }
      t.belongs_to :match_turn,
                   null: false,
                   index: { name: 'idx_cmbtnts_plyrs_mtchs_mvs_mtch_trns_match_turn' }
      t.timestamps
    end
  end
end
