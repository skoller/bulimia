class AddLocationToLogEntry < ActiveRecord::Migration
  def up
    add_column :log_entries, :location, :text 
  end
  
  def down
    remove_column :log_entries, :location
  end
end
