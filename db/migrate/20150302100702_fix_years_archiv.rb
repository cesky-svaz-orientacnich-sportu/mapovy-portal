class FixYearsArchiv < ActiveRecord::Migration
  def up
    year = {}
    
    puts "Loading years"
    
    require 'csv'
    csv = CSV.new(File.open("#{Rails.root}/data/archiv2014.csv"), :col_sep => "\t", :headers => :first_row, :skip_blanks => true)
    csv.readline
    while line = csv.readline
      year[line['ID'].to_i] = line['Rok']
    end
    
    year.each do |fid, xx|
      if map = Map.where(fusion_id: fid).first
        y = if xx.to_i >= 1900
          xx.to_i
        else
          xx[0...4].gsub("?", "0").to_i
        end
        unless map.year == y
          puts "#{map.to_label} : #{map.year} -> #{y}"
          map.year = y
          map.year_accuracy = 'estimate' if xx.include?("?")
          map.save
        end
      end
    end
  end

  def down
  end
end
