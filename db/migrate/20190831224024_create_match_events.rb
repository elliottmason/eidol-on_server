# frozen_string_literal: true

class CreateMatchEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :match_events do |t|
      t.belongs_to :board_position
      t.belongs_to :match_combatant, null: false
      t.belongs_to :match_turns_move, null: false
      t.belongs_to :move_effect, null: false
      t.string :category, null: false
      t.string :property, null: false
      t.integer :amount
      t.string :status
      t.timestamps
    end
  end
end
