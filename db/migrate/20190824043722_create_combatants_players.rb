class CreateCombatantsPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players do |t|

      t.timestamps
    end
  end
end
