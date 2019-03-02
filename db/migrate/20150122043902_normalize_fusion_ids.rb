# -*- encoding : utf-8 -*-
class NormalizeFusionIds < ActiveRecord::Migration
  def up
    Map.where('fusion_id IS NULL OR fusion_id >= 100000').each do |map|
      ofid = map.fusion_id
      map.update_attribute :fusion_id, Map.next_fusion_id
      puts "#{map.title} : ID #{map.id} || fusion ID change #{ofid} --> #{map.fusion_id}"
    end
    fid = Map.pluck(:fusion_id).uniq
    mc = Map.count
    Map.all.each do |m|
      mx = Map.where('id != ? AND fusion_id = ?', m.id, m.fusion_id)
      if mx.any?
        mx.each do |mm|
          am = m.attributes.to_hash
          am.delete("id")
          am.delete("created_at")
          am.delete("updated_at")
          amm = mm.attributes.to_hash
          amm.delete("id")
          amm.delete("created_at")
          amm.delete("updated_at")
          if am == amm
            mm.destroy
          else
            puts "#{m.title} #{m.id} #{m.fusion_id}"
            puts " -> #{mm.title} #{mm.id} #{mm.fusion_id}"
            (am.keys | amm.keys).each do |k|
              unless am[k] == amm[k]
                puts "!!! #{am[k]} #{amm[k]}"
              end
            end
          end
        end
      end
    end
    
    fid = Map.pluck(:fusion_id).uniq
    mc = Map.count    
    fid.size == mc or raise "Nonuniq! There are #{fid.size} unique fusion IDs nad there are #{mc} maps"
    add_index :maps, :fusion_id, unique: true
  end

  def down
  end
end
