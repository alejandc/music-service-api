# == Schema Information
#
# Table name: songs
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  duration   :decimal(6, 2)
#  genre_cd   :integer
#  artist_id  :bigint(8)
#  album_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Song < ApplicationRecord
  belongs_to :album
  belongs_to :artist

  validates :name, :genre, :duration, :artist, :album, presence: true

  as_enum :genre, soul: 0, jazz: 1, techno: 2, rock: 3, folk: 4, classical: 5,
                  reggae: 6, punk: 7, hip_hop: 8, heavy_metal: 9, other: 10

  scope :by_artist, -> (artist_id) { where(artist_id: artist_id) }
  scope :by_album, -> (album_id) { where(album_id: album_id) }

end
