class CreateMatchTurnsMoveTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :match_turns_move_turns do |t|
      t.belongs_to :combatants_players_matches_moves_match_turn,
                   null: false,
                   index: { name: 'idx_mtch_trns_mv_trns_cmbtnts_plyrs_mtchs_mvs_mtch_trn' }
      t.belongs_to :match_turn, null: false
      t.belongs_to :move_turn, null: false
      t.datetime :processed_at
      t.boolean :was_successful
      t.timestamps
    end
  end
end
