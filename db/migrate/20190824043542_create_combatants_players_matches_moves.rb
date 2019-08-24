class CreateCombatantsPlayersMatchesMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_moves do |t|
      t.belongs_to :combatants_players_match, index: false
      t.belongs_to :move
      t.timestamps
    end
  end
end
