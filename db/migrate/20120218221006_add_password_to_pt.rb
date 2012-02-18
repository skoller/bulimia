class AddPasswordToPt < ActiveRecord::Migration
  def up
    add_column :patients, :password_digest, :string
  end
  
  def down
    remove_column :patients, :password_digest
  end
end
