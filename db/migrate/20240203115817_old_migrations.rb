class OldMigrations < ActiveRecord::Migration[7.0]
  REQUIRED_VERSION = 20220806164413
  def up
    if ActiveRecord::Migrator.current_version < REQUIRED_VERSION
      raise StandardError, "`rails db:schema:load` must be run prior to `rails db:migrate`"
    end
  end
end
