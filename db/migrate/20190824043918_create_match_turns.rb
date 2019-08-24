class CreateMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :match_turns do |t|
      t.belongs_to :match
      t.integer :turn, default: 0, null: false
      t.datetime :processed_at
      t.timestamps
    end
  end
end
