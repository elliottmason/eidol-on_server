class CreateMatchCombatantsMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :match_combatants_moves do |t|
      t.belongs_to :match_combatant, null: false
      t.belongs_to :move, null: false
      t.timestamps
    end
  end
end
