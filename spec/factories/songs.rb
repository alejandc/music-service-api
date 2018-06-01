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

FactoryBot.define do
  factory :song do
    name { Faker::StarWars.character }
    duration { Faker::Number.decimal(3, 2)  }
    genre_cd { Song.genres.values.sample }
    artist { create(:artist) }
    album { create(:album) }
  end

  factory :featured_song, class: Song do
    name { Faker::StarWars.character }
    duration { Faker::Number.decimal(3, 2)  }
    genre_cd { Song.genres.values.sample }
    artist { create(:artist) }
    album { create(:album) }
    featured { true }
    featured_text { Faker::Lorem.paragraphs }
  end
end
