class AddConvohandlerReferencesToPt < ActiveRecord::Migration
  def change
    change_table :patients do |t|
      t.references :convo_handler
    end
    add_index :patients, :convo_handler_id
  end
end
