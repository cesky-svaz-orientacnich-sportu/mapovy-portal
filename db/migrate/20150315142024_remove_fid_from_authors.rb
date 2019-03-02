class RemoveFidFromAuthors < ActiveRecord::Migration
  def change
    remove_column :authors, :fusion_id, :integer
  end
end
