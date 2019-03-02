class AddFlagsfilesToMap < ActiveRecord::Migration
  def change
    add_column :maps, :has_jpg, :boolean, default: false, null: false
    add_column :maps, :has_kml, :boolean, default: false, null: false
  end
  def migrate(direction)
    super
    if direction == :up
      Map.find_each do |map|
        map.set_flags
        map.save
      end
    end
  end
end
