class RemovePhysicianPatientRef < ActiveRecord::Migration
  def up
    remove_column :physicians, :patient_id
  end

  def down
  end
end
