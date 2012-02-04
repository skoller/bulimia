class AddColumnConvoHandlerId < ActiveRecord::Migration
  def up
    change_table :log_entries do |t|
      t.references :convo_handler
    end
    add_index :log_entries, :convo_handler_id
  end

  def down
  end
end
