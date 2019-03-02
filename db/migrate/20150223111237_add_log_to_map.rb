class AddLogToMap < ActiveRecord::Migration
  def change
    add_column :maps, :record_log, :text
  end
end
