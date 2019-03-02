# -*- encoding : utf-8 -*-
class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
  end
  def migrate(direction)
    super
    if direction == :up
      User.all.each do |user|
        if user and user.full_name.blank?
          user.update_attribute :full_name, user.authorizations.map(&:name).reject(&:blank?).first
        end
      end
    end
  end
end
