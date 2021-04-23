class ChangeIssomToIsSprOm < ActiveRecord::Migration[6.1]
  def up
  	Map.where(map_type: "issom").update_all(map_type: "issprom")
  end

  def down
  	Map.where(map_type: "issprom").update_all(map_type: "issom")
  end
end
