class CreatePhysicians < ActiveRecord::Migration
  def change
    create_table :physicians do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
