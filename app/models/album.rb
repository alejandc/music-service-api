# == Schema Information
#
# Table name: albums
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  artist_id  :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Album < ApplicationRecord

  belongs_to :artist

  has_many :songs, dependent: :destroy

  has_one_attached :image

  validates :name, :artist, presence: true

  scope :by_artist, -> (artist_id) { where(artist_id: artist_id) }

  def as_json(options = {})
    super(options).merge({
      image: self.image.attachment.try(:filename).try(:to_s),
      songs: self.songs
    })
  end

end
