class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.integer :day
      t.text :food
      t.boolean :binge
      t.boolean :vomit
      t.boolean :laxative
      t.text :personal_notes
      t.string :time

      t.timestamps
    end
  end
end
