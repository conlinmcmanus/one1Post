class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.belongs_to :user, foreign_key: true, on_delete: :cascade
      t.belongs_to :provider
      t.string :uid, unique: true
      t.string :oauth_token
      t.string :oauth_secret
      t.timestamps
    end
  end
end
