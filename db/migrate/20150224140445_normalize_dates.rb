class NormalizeDates < ActiveRecord::Migration
  def up
    Map.find_each do |map|
      d = map.main_race_date      
      d = d.strip if d
      d = d[0...-1] if d && d[-1..-1] == ")"
      d = d[1..-1] if d && d[0..0] == "?" && d.length>4
      d = d.gsub("=","-") if d 
      if d.blank? or d == "-" or d == "?"
        xd = nil
      elsif m = d.match(/^\d\d\d\d-\d\d-\d\d$/)
        # iso
        xd = d
      elsif m = d.match(/^\d\d\d-\d\d-\d\d$/)
        # bad
        xd = nil
      elsif m = d.match(/^(\d\d\d\d)-(\d\d)(-\?)?$/)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, 1]
      elsif m = d.match(/^(\d\d\d\d)-(\d\d)(-\?\?)?$/)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, 1]
      elsif m = d.match(/^(\d\d\d\d)[\.\-](\d\d)[\-\.](\d\d),/)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, m[3].to_i]
      elsif m = d.match(/^(\d\d\d\d)[\.\-](\d\d)[\-\.](\d\d)$/)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, m[3].to_i]
      elsif m = d.match(/^(0\d)-(\d\d)\-(\d{1,2})$/)
        # weird thing 
        xd = "20%02d-%02d-%02d" % [m[1].to_i, m[2].to_i, m[3].to_i]
      elsif m = d.match(/^(\d\d\d\d)(\d\d)\-(\d{1,2})$/)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, m[3].to_i]
      elsif m = d.match(/^(\d\d\d\d)(\d\d)\-(\d{1,2})\.\./)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, m[3].to_i]
      elsif m = d.match(/^(\d\d\d\d)\-(\d{1,2})\-(\d{1,2})\s*[,\?a\.\/]/)
        # weird thing 
        xd = "%04d-%02d-%02d" % [m[1].to_i, m[2].to_i, m[3].to_i]
      elsif m = d.match(/^(\d{1,2})\s*\.\s*(\d{1,2})\s*\.\s*(\d{3,4})$/)
        # cz
        xd = "%04d-%02d-%02d" % [m[3].to_i, m[2].to_i, m[1].to_i]
      elsif m = d.match(/^(\d\d\d\d)\-([a-z]?)/)
        #year
        xd = "#{m[1]}-01-01"
      elsif m = d.match(/^(\d\d\d\d)\s+[a-z]/)
        #year
        xd = "#{m[1]}-01-01"
      elsif m = d.match(/^(\d\d\d\d)\s*(\?)?$/)
        #year
        xd = "#{m[1]}-01-01"
      elsif d == "198?"
        #year
        xd = "1980-01-01"
      elsif d == "196?"
        #year
        xd = "1960-01-01"
      elsif d[0...3] == "???"
        xd = nil
      else 
        raise "???? #{d}"
      end
      
      puts "%5d    %30s %30s" % [map.id, d.to_s, xd.to_s]
      map.update_attribute :main_race_date, xd
    end
    change_column :maps, :main_race_date, :date
  end

  def down
  end
end
