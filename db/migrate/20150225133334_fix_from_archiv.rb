class FixFromArchiv < ActiveRecord::Migration
  def up
    identifier_approval = {}
    printing_technique = {}
    
    puts "Loading"
    
    require 'csv'
    csv = CSV.new(File.open("#{Rails.root}/data/archiv2014.csv"), :col_sep => "\t", :headers => :first_row, :skip_blanks => true)
    csv.readline
    while line = csv.readline
      identifier_approval[line['ID'].to_i] = line['Schval']
      printing_technique[line['ID'].to_i] = line['Tech']
    end
    
    puts "PT"
    printing_technique.each do |fid, xx|
      if map = Map.where(fusion_id: fid).first
        xx = xx.to_s.strip if xx
        x = case xx
        when '1'
          "spot_1"
        when '2'
          "spot_2"
        when '3'
          "spot_3"
        when '4'
          "spot_4"
        when '5'
          "spot_5"
        when '6'
          "spot_6"
        when '7'
          "spot_7"
        when '8'
          "spot_8"
        when '5', '5!', '5+'
          "spot_5"
        when 'C'
          'cmyk'
        when 'C1'
          'cmyk_plus_1'
        when 'C2'
          'cmyk_plus_2'
        when 'B'
          'color_copy'
        when 'L'
          'laser_printer'
        when 'I'
          'inkjet_printer'
        when 'J'
          'other'
        when nil, ""
          nil
        else
          raise "Invalid PT: #{xx}"
        end        
        
        map.update_attribute(:printing_technique, x)
        puts map.to_label
      end
    end
    
    puts "IA"
    identifier_approval.each do |fid, x|
      if map = Map.where(fusion_id: fid).first
        map.update_attribute(:identifier_approval, x)
        puts map.to_label
      end
    end
    
  end

  def down
  end
end
