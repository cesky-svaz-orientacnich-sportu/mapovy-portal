# -*- encoding : utf-8 -*-
class AddRegistrationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :oris_registrations, :string
  end
  def migrate(direction)
    super
    if direction == :up
      User.all.each(&:check_against_oris)
    end
  end
end
