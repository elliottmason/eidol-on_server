class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.belongs_to :account, null: false
      t.belongs_to :match, null: false
      t.string :name, null: false
      t.integer :rank
      t.timestamps
    end
  end
end
