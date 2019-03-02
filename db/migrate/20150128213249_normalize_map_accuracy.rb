# -*- encoding : utf-8 -*-
class NormalizeMapAccuracy < ActiveRecord::Migration
  def up
    changes = {}
    Map.find_each do |map|
      sleep 1
      puts map
      
      changes[map.id] = {}

      # changes[map.id][:printing_technique] = case map.printing_technique
      # when %w{1 2 3 4 5 6 7 8}
      #   "spot_#{map.printing_technique}"
      # when 'C'
      #   'cmyk'
      # when 'C1'
      #   'cmyk_plus_1'
      # when 'C2'
      #   'cmyk_plus_2'
      # when 'B'
      #   'color_copy'
      # when 'L'
      #   'laser_printer'
      # when 'I'
      #   'inkjet_printer'
      # when 'J'
      #   'other'
      # when nil
      #   nil
      # else
      #   raise "Invalid PT for #{map} : #{map.printing_technique.inspect}"
      # end

      changes[map.id][:drawing_technique] = case map.drawing_technique
      when "3"
        "ocad_3"
      when "4"
        "ocad_4"
      when "5"
        "ocad_5"
      when "6"
        "ocad_6"
      when "7"
        "ocad_7"
      when "8"
        "ocad_8"
      when "9"
        "ocad_9"
      when "10", "0"
        "ocad_10"
      when "11", "1"
        "ocad_11"
      when 'k', 'P'
        'pen'
      when 'r'
        'engraving'
      when 'O'
        'ocad'
      when 'B', 'c'
        'color_copy'
      when 'L', 'l'
        'laser_printer'
      when 'I'
        'inkjet_printer'
      when 'J'
        'other'
      when "?"
        nil
      when "-"
        nil
      when ""
        nil
      when nil
        nil
      else
        raise "Invalid DT for #{map} : #{map.drawing_technique.inspect}"
      end unless Map::DRAWING_TECHNIQUES.include?(map.drawing_technique)

      case map.map_sport
      when 'bike'
        changes[map.id][:map_sport] = 'mtbo'
      when 'special'
        changes[map.id][:map_sport] = 'other'
      when 'tourist'
        changes[map.id][:map_sport] = 'extreme'
      end

      case map.map_type
      when 'N'
        changes[map.id][:map_type] = 'none'
      when 'V'
        changes[map.id][:map_type] = 'military'
      when 'I'
        changes[map.id][:map_type] = 'isom'
      when 'S'
        changes[map.id][:map_type] = 'issom'
      when 'L'
        changes[map.id][:map_type] = 'isskiom'
      when 'B'
        changes[map.id][:map_type] = 'ismtbom'
      when 'T'
        changes[map.id][:map_type] = 'topo'
      when 'H'
        changes[map.id][:map_type] = 'none'
        changes[map.id][:map_sport] = 'indoor'
      when 'X'
        changes[map.id][:map_type] = 'none'
      end
      
      changes[map.id][:patron_accuracy] = case map.patron_accuracy
      when ''
        'imprint'
      when '?'
        'estimate'
      when ')'
        'lookup'
      when /^[a-zA-Z]$/, "š"
        'lookup'
      when nil
        nil
      else
        raise "Invalid PA for #{map} : #{map.patron_accuracy.inspect}"
      end unless Map::ACCURACIES.include?(map.patron_accuracy)
      
      changes[map.id][:year_accuracy] = case map.year_accuracy
      when ''
        'imprint'
      when '?'
        'estimate'
      when ')', '2'
        'lookup'
      when /^[a-zA-Z]$/, "š"
        'lookup'
      when nil
        nil
      else
        raise "Invalid YA for #{map} : #{map.year_accuracy.inspect}"
      end unless Map::ACCURACIES.include?(map.year_accuracy)
    end
    changes.each do |id, attrs|
      Map.find(id).update_attributes(attrs)
    end
  end

  def down
  end
end
