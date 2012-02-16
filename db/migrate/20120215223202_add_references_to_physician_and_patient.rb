class AddReferencesToPhysicianAndPatient < ActiveRecord::Migration
  def change
     change_table :patients do |t|
       t.references :physician
     end
     change_table :physicians do |t|
        t.references :patient
      end
     add_index :patients, :physician_id
   end
end
