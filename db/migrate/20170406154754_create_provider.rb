class CreateProvider < ActiveRecord::Migration[5.0]
  def change
    create_table :providers do |t|
      t.string :name
    end
  end
end
