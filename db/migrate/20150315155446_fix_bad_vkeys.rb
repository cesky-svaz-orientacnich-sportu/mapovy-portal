class FixBadVkeys < ActiveRecord::Migration
  def up
    eval(IO.read("#{Rails.root}/db/migrate/mapping.rb"))
    
    @id2f.each do |oid, fid|
      PaperTrail::Version.where('id <= 30463').where(item_type: 'Map', item_id: oid).each do |v|
        v.update_attribute :item_id, fid
      end
    end
  end
end
