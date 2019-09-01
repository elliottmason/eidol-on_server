class CreateMatchCombatantStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :match_combatant_statuses do |t|
      t.belongs_to :match_combatant, null: false
      t.belongs_to :match_event, null: false
      t.integer :defense, null: false
      t.integer :level, null: false
      t.integer :maximum_energy, null: false
      t.integer :maximum_health, null: false
      t.integer :remaining_energy, null: false
      t.integer :remaining_health, null: false
      t.string :availability, null: false
      t.timestamps
    end
  end
end
