class AddObmapurlToOrisEvent < ActiveRecord::Migration
  def change
    add_column :oris_events, :obpostupy_map_url, :string
  end
end
