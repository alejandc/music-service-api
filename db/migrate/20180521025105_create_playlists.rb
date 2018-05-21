class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :name

      t.references :user, index: true

      t.timestamps
    end

    create_table :playlists_songs, id: false do |t|
      t.references :song, index: true
      t.references :playlist, index: true
    end
  end
end
