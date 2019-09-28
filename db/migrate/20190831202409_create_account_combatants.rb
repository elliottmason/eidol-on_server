class CreateAccountCombatants < ActiveRecord::Migration[6.0]
  def change
    create_table :account_combatants do |t|
      t.belongs_to :account, null: false
      t.belongs_to :combatant, null: false
      t.timestamps
    end
  end
end
