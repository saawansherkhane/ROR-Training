class AddStatusToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :status, :boolean
  end
end
