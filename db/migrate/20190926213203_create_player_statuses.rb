class CreatePlayerStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :player_statuses do |t|
      t.belongs_to :match_turn, null: false
      t.belongs_to :player, null: false
      t.string :availability, null: false
      t.timestamps
    end
  end
end
