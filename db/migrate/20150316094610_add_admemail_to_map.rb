class AddAdmemailToMap < ActiveRecord::Migration
  def change
    add_column :maps, :administrator_email, :string
  end
  
  def migrate(d)
    super
    Map.find_each do |map|
      if !map.administrator.blank? and m = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i.match(map.administrator)
        puts "#{map.to_label} -> #{m.to_s}"
        map.update_attribute :administrator_email, m.to_s
      end
    end
  end
end
