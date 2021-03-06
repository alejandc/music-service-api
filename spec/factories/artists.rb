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

FactoryBot.define do
  factory :artist do
    name { Faker::StarWars.character }
    biography { Faker::Lorem.paragraphs  }
  end
end
