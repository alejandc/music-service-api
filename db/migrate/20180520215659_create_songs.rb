class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name
      t.decimal :duration, precision: 6, scale: 2
      t.integer :genre_cd

      t.references :artist
      t.references :album

      t.timestamps
    end
  end
end
