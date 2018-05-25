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

FactoryBot.define do
  factory :album do
    name { Faker::StarWars.character }
    artist { create(:artist)  }
  end

  factory :album_with_image, class: Album do
    name { Faker::StarWars.character }
    artist { create(:artist)  }

    after(:create) do |culture|
      culture.image.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'test_image.jpeg')),
                           filename: 'test_image.jpeg', 
                           content_type: 'image/jpeg')
    end
  end
end
