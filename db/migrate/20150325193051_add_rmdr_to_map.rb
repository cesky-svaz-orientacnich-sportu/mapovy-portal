class AddRmdrToMap < ActiveRecord::Migration
  def change
    add_column :maps, :last_reminder_sent_at, :date
    add_column :maps, :state_changed_at, :date
  end
  def migrate(direction)
    super
    if direction == :up
      Map.where('state != ? AND state != ?', Map::STATE_ARCHIVED, Map::STATE_SAVED_WITHOUT_FILING).find_each do |map|
        map.update_attribute :state_changed_at, map.updated_at.to_date
      end
    end
  end
end
