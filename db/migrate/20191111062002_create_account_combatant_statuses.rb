class CreateAccountCombatantStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :account_combatant_statuses do |t|
      t.belongs_to :account_combatant, null: false
      t.integer :exp, null: false
      t.integer :defense, null: false
      t.integer :health, null: false
      t.timestamps
    end
  end
end
