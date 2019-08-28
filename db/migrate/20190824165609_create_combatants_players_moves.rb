class CreateCombatantsPlayersMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_moves do |t|
      t.belongs_to :combatants_player, null: false
      t.belongs_to :move, null: false
      t.timestamps
    end
  end
end
