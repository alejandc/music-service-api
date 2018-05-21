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

FactoryBot.define do
  factory :song do
    name { Faker::StarWars.character }
    duration { Faker::Number.decimal(3, 2)  }
    genre_cd { Song.genres.values.sample }
    artist { create(:artis) }
    album { create(:album) }
  end
end