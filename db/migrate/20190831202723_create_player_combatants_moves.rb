class CreatePlayerCombatantsMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :player_combatants_moves do |t|
      t.belongs_to :move, null: false
      t.belongs_to :player_combatant, null: false
      t.timestamps
    end
  end
end
