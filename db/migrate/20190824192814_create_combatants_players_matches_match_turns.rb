class CreateCombatantsPlayersMatchesMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_match_turns do |t|
      t.belongs_to :combatants_players_match,
                   null: false,
                   index: { name: 'idx_cmbtnts_plyrs_mtchs_match_turns_combatants_players_match' }
      t.belongs_to :match_event, null: false
      t.belongs_to :match_turn, null: false
      t.integer :level, null: false
      t.integer :remaining_health, null: false
      t.integer :defense, null: false
      t.string :availability, null: false
      t.timestamps
    end
  end
end
