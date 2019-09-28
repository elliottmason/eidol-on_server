class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :email_address, null: false, index: { unique: true }
      t.string :username, null: false
      t.timestamps
    end
  end
end
