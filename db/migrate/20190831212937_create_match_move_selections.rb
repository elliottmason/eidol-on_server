# frozen_string_literal: true

class CreateMatchMoveSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :match_move_selections do |t|
      t.belongs_to :board_position
      t.belongs_to :match_combatants_move, null: false
      t.belongs_to :match_turn, null: false
      t.belongs_to :player
      t.boolean :was_system_selected, null: false, default: false
      t.datetime :processed_at
      t.timestamps
    end
  end
end
