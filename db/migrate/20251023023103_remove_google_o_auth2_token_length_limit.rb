class RemoveGoogleOAuth2TokenLengthLimit < ActiveRecord::Migration[8.0]
  def up
      change_column :authorizations, :token, :text
    end

    def down
      change_column :authorizations, :token, :string, limit: 255
    end
end
