class AddStatusToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :status, :boolean
    add_column :customers, :branch_id, :integer
  end
end
