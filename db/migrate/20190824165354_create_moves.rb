# frozen_string_literal: true

class CreateMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :moves do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :energy_cost, null: false
      t.boolean :is_diagonal, null: false
      t.integer :speed, null: false
      t.integer :range, null: false
      t.timestamps
    end
  end
end
