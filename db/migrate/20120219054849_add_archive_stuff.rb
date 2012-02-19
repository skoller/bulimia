class AddArchiveStuff < ActiveRecord::Migration
  def up
    add_column :physicians, :archive, :boolean
    add_column :physicians, :first_name, :string
    add_column :physicians, :last_name, :string
    add_column :physicians, :state, :string
    add_column :physicians, :specialty, :string
    add_column :patients, :archive, :boolean
  end

  def down
    remove_column :physicians, :archive
    remove_column :physicians, :first_name
    remove_column :physicians, :last_name
    remove_column :physicians, :state
    remove_column :physicians, :specialty
    remove_column :patients, :archive
  end
end
