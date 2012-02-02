class AddPhoneNum < ActiveRecord::Migration
  def up
    add_column :patients, :phone_number, :string
      
  end

  def down
    remove_column :patients, :phone_number
  end
end
