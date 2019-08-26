class CreateBoardPositionsMatchTurns < ActiveRecord::Migration[6.0]
  def change
    create_join_table :board_positions, :match_turns do |t|
      t.string :availability, null: false
      t.timestamps
    end
  end
end
