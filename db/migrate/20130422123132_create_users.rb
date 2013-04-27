class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :name
      t.string :password_hash
      t.boolean :is_admin

      t.timestamps
    end
  end
end
