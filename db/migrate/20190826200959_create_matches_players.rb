class CreateMatchesPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :matches_players do |t|
      t.belongs_to :match, null: false
      t.belongs_to :player, null: false
      t.timestamps
    end
  end
end
