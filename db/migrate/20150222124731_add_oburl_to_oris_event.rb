class AddOburlToOrisEvent < ActiveRecord::Migration
  def change
    add_column :oris_events, :obpostupy_url, :string
  end
end
