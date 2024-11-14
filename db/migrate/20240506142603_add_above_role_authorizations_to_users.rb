class AddAboveRoleAuthorizationsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :above_role_authorizations, :integer, array: true, null: false, default: []
  end
end
