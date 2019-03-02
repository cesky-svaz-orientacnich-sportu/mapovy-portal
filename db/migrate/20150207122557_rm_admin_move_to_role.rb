class RmAdminMoveToRole < ActiveRecord::Migration
  def up
    User.all.each do |u|
      if u.admin?
        u.role = 'admin'
        u.save
      end
    end
    remove_column :users, :admin
  end

  def down
    raise IrreversibleMigration
  end
end
