# == Schema Information
#
# Table name: playlists
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Playlist < ApplicationRecord
  before_destroy { songs.delete_all }

  belongs_to :user

  has_and_belongs_to_many :songs

  validates :name, :user, presence: true

  scope :by_user, -> (user_id) { where(user_id: user_id) }

  def as_json(options)
    super(options).merge({
      songs: self.songs
    })
  end

end
