class CreateAccountTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :account_transactions do |t|
      t.integer :account_id
      t.integer :from_id
      t.integer :to_id
      t.text :description
      t.decimal :amount, :default => 0.0

      t.timestamps
    end
  end
end
