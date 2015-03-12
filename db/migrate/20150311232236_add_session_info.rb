class AddSessionInfo < ActiveRecord::Migration
  def change
    add_column :sessions, :environment, :string
    add_column :sessions, :location, :string
  end
end
