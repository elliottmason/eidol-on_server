class CreateCombatantsPlayersMatchesMoveSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_move_selections do |t|
      t.belongs_to :board_position,
                   index: { name: 'index_combatants_players_matches_move_selections_board_position' }
      t.belongs_to :combatants_players_matches_move,
                   null: false,
                   index: { name: 'idx_cmbtnts_plyrs_mtchs_mv_slctns_cmbtnts_plyrs_mtchs_mv'}
      t.belongs_to :match_turn,
                   null: false,
                   index: { name: 'index_combatants_players_matches_move_selections_match_turn' }
      t.datetime :processed_at
      t.boolean :was_successful
      t.timestamps
    end
  end
end
