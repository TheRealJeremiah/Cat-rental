class AddUserIdToCats < ActiveRecord::Migration
  def change
    add_column :cats, :user_id, :integer, null: false, default: 4
    add_index :cats, :user_id
  end
end
