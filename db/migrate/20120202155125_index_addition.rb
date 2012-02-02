class IndexAddition < ActiveRecord::Migration
  def up
    change_table :log_entries do |t|
      t.references :patient
    end
    add_index :log_entries, :patient_id
  end

  def down
  end
end
