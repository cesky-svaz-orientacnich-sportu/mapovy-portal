class AddCplmbyToMap < ActiveRecord::Migration
  def change
    add_column :maps, :completed_by_id, :integer
  end
  def migrate(direction)
    super
    if direction == :up
      Map.find_each do |map|
        map.update_attribute :completed_by_id, map.created_by_id
      end
    end
  end
end
