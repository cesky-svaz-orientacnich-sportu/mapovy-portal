class RemoveInvalidObPostupyData < ActiveRecord::Migration[8.0]
  def change
    remove_column :oris_events, :obpostupy_url, :string, limit: 255
    remove_column :oris_events, :obpostupy_map_url, :string, limit: 255
  end
end
