# -*- encoding : utf-8 -*-
class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :name
      t.text :body_cs
      t.text :body_en

      t.timestamps
    end
  end
end
