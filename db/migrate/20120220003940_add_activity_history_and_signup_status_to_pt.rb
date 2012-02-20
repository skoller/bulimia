class AddActivityHistoryAndSignupStatusToPt < ActiveRecord::Migration
  def up
    add_column :patients, :signup_status, :string
    add_column :patients, :activity_history, :text
  end
  
  def down
    remove_column :patients, :signup_status
    remove_column :patients, :activity_history
  end
end
