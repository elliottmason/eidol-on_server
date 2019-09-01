class CreateMatchMoveTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :match_move_turns do |t|
      t.belongs_to :match_combatant, null: false
      t.belongs_to :match_move_selection
      t.belongs_to :match_turn, null: false
      t.belongs_to :move_turn, null: false
      t.datetime :processed_at
      t.timestamps
    end
  end
end
