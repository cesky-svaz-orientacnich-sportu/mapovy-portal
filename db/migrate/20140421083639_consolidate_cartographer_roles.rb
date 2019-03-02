# -*- encoding : utf-8 -*-
class ConsolidateCartographerRoles < ActiveRecord::Migration
  def up
    Cartographer.all.each do |c|
      if c.role.blank?
        c.role = 'J'
      else
        c.role = c.role.upcase
      end
      c.save
    end
  end

  def down
  end
end
