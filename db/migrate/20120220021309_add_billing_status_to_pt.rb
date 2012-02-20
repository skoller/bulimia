class AddBillingStatusToPt < ActiveRecord::Migration
  def up
    add_column :patients, :billing_status, :string
  end
  def down
    remove_column :patients, :billing_status
  end
end
