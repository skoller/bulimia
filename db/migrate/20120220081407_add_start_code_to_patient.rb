class AddStartCodeToPatient < ActiveRecord::Migration
  def up
    add_column :patients, :start_code, :string
  end
  
  def down
    remove_column :patients, :start_code
  end
end
