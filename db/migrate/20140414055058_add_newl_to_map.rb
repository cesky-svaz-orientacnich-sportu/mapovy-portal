# -*- encoding : utf-8 -*-
class AddNewlToMap < ActiveRecord::Migration
  def change
    add_column :maps, :map_family, :string
    add_column :maps, :map_sport, :string
  end
  def migrate(direction)
    super
    if direction == :up
      Map.all.each do |m|
        puts m.to_label
        begin
          m.migrate_layers
        rescue StandardError => e
          puts e
          sleep(2)
          retry
        end
        sleep(1)
      end
    end
  end
end
