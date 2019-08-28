class CreateCombatantsPlayersMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches do |t|
      t.belongs_to :combatants_player, null: false
      t.belongs_to :match
      t.integer :defense, null: false
      t.integer :health, null: false
      t.integer :level, null: false
      t.timestamps
    end
  end
end
