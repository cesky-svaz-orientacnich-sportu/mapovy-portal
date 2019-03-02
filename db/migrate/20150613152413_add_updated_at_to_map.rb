class AddUpdatedAtToMap < ActiveRecord::Migration
  def change
    add_column :maps, :user_updated_at, :datetime
  end
  def migrate(direction)
    super
    if direction == :up
      Map.find_each do |m|
        m.update_attribute :user_updated_at, :updated_at
      end
    end
  end
end
