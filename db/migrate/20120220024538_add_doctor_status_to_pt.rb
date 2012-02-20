class AddDoctorStatusToPt < ActiveRecord::Migration
  def up
    add_column :patients, :doctor_status, :string
  end
  
  def down
    remove_column :patients, :doctor_status
    
  end
end
