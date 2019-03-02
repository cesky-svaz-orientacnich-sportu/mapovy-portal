class AddAuthxToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authorized_clubs, :string
    add_column :users, :authorized_regions, :string
  end
end
