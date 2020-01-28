class AddNonOrisEventUrl < ActiveRecord::Migration
  def up
  	add_column :maps, :non_oris_event_url, :string, { limit: 255, null: true }
  end

  def down
  	remove_column :maps, :non_oris_event_url, :string
  end
end
