# -*- encoding : utf-8 -*-
class CreateCartographers < ActiveRecord::Migration
  def change
    create_table :cartographers do |t|
      t.integer :map_id
      t.integer :author_id
      t.string :role

      t.timestamps
    end
  end
  def migrate(direction)
    super
    if direction == :up
      
      fusion_table ||= Fusion.table( Mapserver::Application.config.maps_fusion_table_id)
      fusion_table.select("*").each do |ft|
        map = Map.where(:fusion_id => ft[:id]).first
        map or raise("kvac!")
        ((ft[:propojeni] || "").split(",") || []).reject(&:blank?).each do |x|
          next if x.strip == 'NULL'
          role, author_fusion_id = *x.split(':')
          next if author_fusion_id.blank?
          author = Author.where(:fusion_id => author_fusion_id.to_i).first 
          author or raise("mnau! #{x} - #{author_fusion_id} - #{author}")
          Cartographer.create(
            :role => role,
            :map_id => map.id,
            :author_id => author.id
          ) 
        end
      end
    end
  end
end
