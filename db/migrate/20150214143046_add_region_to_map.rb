class AddRegionToMap < ActiveRecord::Migration
  def change
    add_column :maps, :region, :string
  end
end
