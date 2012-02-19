class AddArchIdPhys < ActiveRecord::Migration
  def up
    add_column :physicians, :arch_id, :integer
  end

  def down
    remove_column :physicians, :arch_id
  end
end
