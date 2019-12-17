# frozen_string_literal: true

class CreateMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :match_turns do |t|
      t.belongs_to :match, null: false
      t.integer :turn, null: false
      t.datetime :processed_at
      t.timestamps
    end
  end
end
