class AddDateColumn < ActiveRecord::Migration
  def up
    add_column :log_entries, :date, :datetime
  end

  def down
    remove_column :log_entries, :date
  end
end
