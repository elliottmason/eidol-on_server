# frozen_string_literal: true

class CreateMatchTurnsMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :match_turns_moves do |t|
      t.belongs_to :match_combatant, null: false
      t.belongs_to :match_move_selection
      t.belongs_to :match_turn, null: false
      t.belongs_to :move, null: false
      t.datetime :processed_at
      t.timestamps
    end
  end
end
