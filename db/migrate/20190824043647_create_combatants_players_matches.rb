class CreateCombatantsPlayersMatches < ActiveRecord::Migration[6.0]
  def change
    create_join_table :combatants_players, :matches do |t|
      t.integer :defense, null: false
      t.integer :health, null: false
      t.integer :level, null: false
      t.timestamps
    end
  end
end
