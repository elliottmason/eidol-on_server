# frozen_string_literal: true

class CreateCombatants < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants do |t|
      t.string :name, null: false
      t.integer :base_agility, null: false
      t.integer :base_defense, null: false
      t.integer :base_health, null: false
      t.integer :maximum_energy, null: false
      t.integer :initial_remaining_energy, null: false
      t.integer :energy_per_turn, null: false
      t.timestamps
    end
  end
end
