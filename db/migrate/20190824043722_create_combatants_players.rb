class CreateCombatantsPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players do |t|
      t.belongs_to :combatant, null: false
      t.belongs_to :player, null: false
      t.timestamps
    end
  end
end
