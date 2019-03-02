# -*- encoding : utf-8 -*-
class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :abbreviation
      t.string :region
      t.string :district
      t.string :url
      t.string :division

      t.timestamps
    end
  end
  def migrate(direction)
    super
    if direction == :up
      doc = Nokogiri::XML(File.open "#{Rails.root}/db/migrate/adresar.xml")
      doc.root.css('oddil').each do |e|
        Club.create(
          :name => e.css('nazev').text.strip,
          :abbreviation => e.css('id').text.strip,
          :region => e.css('naz_kra').text.strip,
          :district => e.css('naz_okr').text.strip,
          :url => e.css('http').text.strip,
          :division => e.css('naz_obl').text.strip
        )
      end
    end
  end
end
