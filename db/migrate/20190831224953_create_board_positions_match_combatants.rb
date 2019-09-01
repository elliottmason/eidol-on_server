class CreateBoardPositionsMatchCombatants < ActiveRecord::Migration[6.0]
  def change
    create_table :board_positions_match_combatants do |t|
      t.belongs_to :board_position, null: false
      t.belongs_to :match_combatant, null: false
      t.belongs_to :match_event
      t.timestamps
    end
  end
end
