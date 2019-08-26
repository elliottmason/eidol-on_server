class CreateCombatantsPlayersMatchesMoves < ActiveRecord::Migration[6.0]
  def change
    create_join_table :combatants_players_matches, :moves do |t|
      t.timestamps
    end
  end
end
