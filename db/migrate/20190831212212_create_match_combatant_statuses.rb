class CreateMatchCombatantStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :match_combatant_statuses do |t|
      t.belongs_to :board_position
      t.belongs_to :match_combatant, null: false
      t.belongs_to :match_event
      t.integer :remaining_health, null: false
      t.string :availability, null: false
      t.timestamps
    end
  end
end
