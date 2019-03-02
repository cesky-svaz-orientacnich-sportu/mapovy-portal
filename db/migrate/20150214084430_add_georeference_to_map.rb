class AddGeoreferenceToMap < ActiveRecord::Migration
  def change
    add_column :maps, :georeference, :string
  end
end
