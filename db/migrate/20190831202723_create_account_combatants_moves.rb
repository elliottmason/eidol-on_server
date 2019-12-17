# frozen_string_literal: true

class CreateAccountCombatantsMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :account_combatants_moves do |t|
      t.belongs_to :account_combatant, null: false
      t.belongs_to :move, null: false
      t.timestamps
    end
  end
end
