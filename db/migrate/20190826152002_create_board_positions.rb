# frozen_string_literal: true

class CreateBoardPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :board_positions do |t|
      t.belongs_to :match, null: false
      t.integer :x, null: false
      t.integer :y, null: false
      t.timestamps
    end
  end
end
