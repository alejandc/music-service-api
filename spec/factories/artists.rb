FactoryBot.define do
  factory :artist do
    name { Faker::StarWars.character }
    biography { Faker::Lorem.paragraphs  }
  end
end
