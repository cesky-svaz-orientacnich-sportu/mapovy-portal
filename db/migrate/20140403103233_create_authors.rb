# -*- encoding : utf-8 -*-
class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.integer :fusion_id
      t.string :note
      t.string :full_name
      t.string :club
      t.string :activity
      t.integer :year_of_birth

      t.timestamps
    end
  end

  
  def migrate(direction)
    super
    if direction == :up
      tbl = Fusion::table(AUTHORS_FUSION_TABLE_ID)
      tbl.select.each do |row|
        Author.create(
          :fusion_id => row[:id_autor],
          :note => row[:pozn],
          :full_name => row[:celejmeno],
          :club => row[:klub],
          :activity => row[:rokakt],
          :year_of_birth => row[:roknar].to_i
        )
      end
    end
  end
end

