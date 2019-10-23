class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.datetime :ended_at
      t.timestamps
    end
  end
end
