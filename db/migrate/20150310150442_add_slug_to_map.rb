class AddSlugToMap < ActiveRecord::Migration
  
  def change
    add_column :maps, :slug, :string
    add_index :maps, :slug, unique: true
  end
  
  def migrate(d)
    super
    if d == :up
      Map.find_each(&:save)
    end
  end
  
end
