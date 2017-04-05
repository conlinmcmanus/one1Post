class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.references :user, foreign_key: true, on_delete: :cascade
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
