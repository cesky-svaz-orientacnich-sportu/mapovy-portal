class AddBlockingReasonToMap < ActiveRecord::Migration[6.1]
  def up
    add_column :maps, :blocking_reason, :text, { null: true }
  end

  def down
    remove_column :maps, :blocking_reason, :text
  end
end
