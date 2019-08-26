class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.belongs_to :board, null: false
      t.timestamps
    end
  end
end
