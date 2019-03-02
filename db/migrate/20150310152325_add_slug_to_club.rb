class AddSlugToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :slug, :string
    add_index :clubs, :slug, unique: true
  end

  
  def migrate(d)
    super
    if d == :up
      Club.find_each(&:save)
    end
  end
  

end
