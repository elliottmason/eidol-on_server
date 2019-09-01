class CreateMatchCombatants < ActiveRecord::Migration[6.0]
  def change
    create_table :match_combatants do |t|
      t.belongs_to :match, null: false
      t.belongs_to :player_combatant, null: false
      t.integer :defense, null: false
      t.integer :health, null: false
      t.integer :level, null: false
      t.timestamps
    end
  end
end
