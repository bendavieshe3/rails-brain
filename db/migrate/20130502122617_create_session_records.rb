class CreateSessionRecords < ActiveRecord::Migration
  def change
    create_table :session_records do |t|
      t.integer :user_id
      t.string :key

      t.timestamps
    end
  end
end
