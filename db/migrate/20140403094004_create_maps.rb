# -*- encoding : utf-8 -*-
class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :fusion_id
      t.string :title
      t.string :patron
      t.string :patron_accuracy
      t.integer :year
      t.string :year_accuracy
      t.integer :scale
      t.string :archive_print1_class
      t.string :archive_print2_class
      t.string :archive_print3_class
      t.integer :archive_extra_print_count
      t.float :equidistance
      t.string :identifier_other
      t.string :locality
      t.float :area_size
      t.string :issued_by
      t.string :printed_by
      t.string :map_type
      t.string :drawing_technique
      t.string :printing_technique
      t.string :resource
      t.string :main_race_title
      t.string :main_race_date
      t.text :administrator
      t.string :identifier_approval
      t.string :identifier_filing
      t.text :note_public
      t.text :note_internal
      t.string :preview_identifier
      t.integer :layer_index

      t.timestamps
    end
  end
  
  def migrate(direction)
    super
    if direction == :up
      tbl = Fusion::table( Mapserver::Application.config.maps_fusion_table_id)
      tbl.select.each do |row|
        Map.create(
          :fusion_id => row[:id],
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
      end
    end
  end
end
