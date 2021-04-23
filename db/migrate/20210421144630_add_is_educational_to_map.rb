class AddIsEducationalToMap < ActiveRecord::Migration[6.1]
  def up
    add_column :maps, :is_educational, :boolean, { default: false, null: false }
    Map.where("LOWER(note_public) LIKE LOWER(?)", "%objev%").update_all('is_educational = TRUE')
  end

  def down
    remove_column :maps, :is_educational, :boolean
  end
end
