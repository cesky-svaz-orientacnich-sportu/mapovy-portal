# -*- encoding : utf-8 -*-
class LoadDestroyedData < ActiveRecord::Migration
  def up
    fusion_ids = Map.fusion_table.select("ID").map{|x| x[:id].to_i}.uniq
    
    fusion_ids.each do |id|
      next if Map.where(fusion_id: id).any?
    
      row = Map.fusion_table.select("*", "WHERE ID=#{id}").first
      puts "#{id} --> #{row[:nazev]}"
      map = Map.create(
        :title => row[:nazev],
        :patron => row[:patron],
        :patron_accuracy => row[:patron_mj],
        :year => row[:rok],
        :year_accuracy => row[:rok_mj],
        :scale => row[:meritko].to_i,
        :archive_print1_class => row[:archiv][0..0],
        :archive_print2_class => row[:archiv][1..1],
        :archive_print3_class => row[:archiv][2..2],
        :archive_extra_print_count => row[:archiv][3..3].to_i,
        :equidistance => row[:ekv].to_f,
        :identifier_other => row[:jine_cislo],
        :locality => row[:misto],
        :area_size => row[:plocha].to_f,
        :issued_by => row[:vydavatel],
        :printed_by => row[:tiskarna],
        :map_type => row[:typ],
        :drawing_technique => row[:kres],
        :printing_technique => row[:tech_tisk],
        :resource => row[:podklad],
        :main_race_title => row[:zavod],
        :main_race_date => row[:dat_zav],
        :administrator => row[:spravce],
        :identifier_approval => row[:schval],
        :identifier_filing => row[:evid_cislo],
        :note_public => row[:pozn],
        :note_internal => row[:nev_poznam],
        :preview_identifier => row[:obraz],
        :layer_index => row[:groupnum]
      )
      map.update_attribute(:fusion_id, id)
      sleep 0.5
    end
  end

  def down
  end
end
