class CreateCombatantsPlayersMatchesMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :combatants_players_matches_moves do |t|
      t.belongs_to :combatants_players_match,
                   null: false,
                   index: { name: 'idx_combatants_players_matches_moves_combatants_players_match' }
      t.belongs_to :move, null: false
      t.timestamps
    end
  end
end
