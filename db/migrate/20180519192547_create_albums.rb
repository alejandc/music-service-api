class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :name, index: true

      t.references :artist, index: true

      t.timestamps
    end
  end
end
