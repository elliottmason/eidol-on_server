class CreateCombatantsPlayersMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches do |t|
      t.belongs_to :combatants_player
      t.belongs_to :match
      t.timestamps
    end
  end
end
