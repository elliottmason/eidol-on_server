# frozen_string_literal: true

class CreateMoveTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :move_turns do |t|
      t.belongs_to :move, null: false
      t.integer :turn, null: false
      t.integer :speed, null: false
      t.timestamps
    end
  end
end
