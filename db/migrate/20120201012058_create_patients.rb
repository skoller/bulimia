class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :dob
      t.string :sex
      t.float :diagnosis

      t.timestamps
    end
  end
end
