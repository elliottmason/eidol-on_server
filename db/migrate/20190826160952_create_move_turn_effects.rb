class CreateMoveTurnEffects < ActiveRecord::Migration[6.0]
  def change
    create_table :move_turn_effects do |t|
      t.belongs_to :move_turn, null: false
      t.string :effect_type, null: false
      t.string :property
      t.integer :power, default: 0, null: false
      t.integer :precedence, default: 0, null: false
      t.timestamps
    end
  end
end
