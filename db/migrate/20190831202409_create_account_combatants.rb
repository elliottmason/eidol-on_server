# frozen_string_literal: true

class CreateAccountCombatants < ActiveRecord::Migration[6.0]
  def change
    create_table :account_combatants do |t|
      t.belongs_to :account, null: false
      t.belongs_to :combatant, null: false
      t.integer :individual_agility, null: false
      t.integer :individual_defense, null: false
      t.integer :individual_health, null: false
      t.integer :individual_power, null: false
      t.timestamps
    end
  end
end
