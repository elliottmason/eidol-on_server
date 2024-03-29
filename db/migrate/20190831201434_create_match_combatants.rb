# frozen_string_literal: true

class CreateMatchCombatants < ActiveRecord::Migration[6.0]
  def change
    create_table :match_combatants do |t|
      t.belongs_to :account_combatant, null: false
      t.belongs_to :player, null: false
      t.integer :agility, null: false
      t.integer :defense, null: false
      t.integer :level, null: false
      t.integer :maximum_energy, null: false
      t.integer :maximum_health, null: false
      t.timestamps
    end
  end
end
