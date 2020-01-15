# frozen_string_literal: true

class CreateMoveEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :move_effects do |t|
      t.belongs_to :move, null: false
      t.string :category, null: false
      t.string :property, null: false
      t.integer :power, default: 0, null: false
      t.timestamps
    end
  end
end
