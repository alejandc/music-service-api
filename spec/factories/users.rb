FactoryBot.define do
  factory :user do
    name { Faker::StarWars.character }
    email { 'test@test.com' }
    password { 'test123' }
  end
end
