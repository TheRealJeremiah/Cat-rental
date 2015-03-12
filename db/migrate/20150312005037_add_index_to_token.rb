class AddIndexToToken < ActiveRecord::Migration
  def change
    add_index :sessions, :token
  end
end
