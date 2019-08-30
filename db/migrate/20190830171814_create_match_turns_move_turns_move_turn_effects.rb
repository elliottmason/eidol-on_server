class CreateMatchTurnsMoveTurnsMoveTurnEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :match_turns_move_turns_move_turn_effects do |t|
      t.belongs_to :combatants_players_match,
                   null: false,
                   index: { name: 'idx_mtch_trns_mv_trns_mv_trn_ffcts_cmbtnts_plyrs_mtch'}
      t.belongs_to :board_position,
                   index: { name: 'idx_mtch_trns_mv_trns_mv_trn_ffcts_brd_pstn' }
      t.belongs_to :match_turns_move_turn, null: false,
                   index: { name: 'idx_mtch_trns_mv_trns_mv_trn_ffcts_mtch_trns_mv_trn' }
      t.belongs_to :move_turn_effect, null: false,
                   index: { name: 'idx_mtch_trns_mv_trns_mv_trn_ffcts_mv_trns_ffct' }
      t.string :effect_type, null: false
      t.integer :amount
      t.string :status
      t.timestamps
    end
  end
end
