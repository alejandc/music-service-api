# == Schema Information
#
# Table name: songs
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  duration      :integer
#  genre_cd      :integer
#  artist_id     :bigint(8)
#  album_id      :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  featured      :boolean          default(FALSE)
#  featured_text :text
#

class Song < ApplicationRecord
  include SongSearchable

  before_destroy { playlists.delete_all }

  belongs_to :album
  belongs_to :artist

  has_and_belongs_to_many :playlists

  has_one_attached :image

  validates :name, :genre, :duration, :artist, :album, presence: true

  as_enum :genre, soul: 0, jazz: 1, techno: 2, rock: 3, folk: 4, classical: 5,
                  reggae: 6, punk: 7, hip_hop: 8, heavy_metal: 9, other: 10

  scope :by_artist, -> (artist_id) { where(artist_id: artist_id) }
  scope :by_album, -> (album_id) { where(album_id: album_id) }
  scope :featured, -> (featured) { where(featured: featured) }

  def as_json(options = {})
    super(options).merge({
      image: self.image.attachment.try(:filename).try(:to_s)
    })
  end


  def self.search(filters)
    songs = self

    if filters && filters['featured'].present?
      songs = songs.featured(filters[:featured])
    end

    if filters && filters['artist_id'].present?
      songs = songs.by_artist(filters[:artist_id])
    end

    songs.order('created_at DESC')
  end

end
