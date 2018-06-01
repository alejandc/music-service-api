# == Schema Information
#
# Table name: artists
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  biography  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Artist < ApplicationRecord

  has_many :albums, dependent: :destroy
  has_many :songs

  validates :name, presence: true

  def as_json(options = {})
    super(options).merge({
      albums: self.albums
    })
  end

end
