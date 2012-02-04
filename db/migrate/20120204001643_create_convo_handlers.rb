class CreateConvoHandlers < ActiveRecord::Migration
  def change
    create_table :convo_handlers do |t|
      t.string :state
      t.references :patient
      t.references :log_entry
      
      t.timestamps
    end
    add_index :convo_handlers, :patient_id
    add_index :convo_handlers, :log_entry_id
  end
end
