class CreateMatchTurnsMoveTurns < ActiveRecord::Migration[6.0]
  def change
    create_join_table :match_turns, :move_turns do |t|
      t.belongs_to :combatants_players_matches_move_selection,
                   null: false,
                   index: { name: 'index_match_turns_move_turns_on_move_selection_id' }
      t.datetime :processed_at
      t.boolean :was_successful
      t.timestamps
    end
  end
end
