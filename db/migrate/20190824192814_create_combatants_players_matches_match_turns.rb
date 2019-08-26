class CreateCombatantsPlayersMatchesMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_join_table :combatants_players_matches, :match_turns do |t|
      t.belongs_to :match_event
      t.integer :level, null: false
      t.integer :remaining_health, null: false
      t.integer :defense, null: false
      t.string :availability, null: false
      t.timestamps
    end
  end
end
