class AddFeaturedSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :featured, :boolean, default: false, index: true
    add_column :songs, :featured_text, :text
  end
end
