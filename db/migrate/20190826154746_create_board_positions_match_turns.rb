class CreateBoardPositionsMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_table :board_positions_match_turns do |t|
      t.belongs_to :board_position, null: false
      t.belongs_to :match_turn, null: false
      t.string :availability, null: false
      t.timestamps
    end
  end
end
