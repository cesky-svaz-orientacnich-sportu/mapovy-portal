class AddStateToMap < ActiveRecord::Migration
  def change
    add_column :maps, :state, :string
  end
  def migrate(direction)
    super
    if direction == :up
      Map.all.each do |map|
        if map.map_family == 'map__proposed'
          map.map_family == 'map'
          map.state = 'proposed'
        else
          map.state = 'archived'
        end
        map.save
      end
    end
  end
end
