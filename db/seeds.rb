# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

User.create!(name: 'Test User', email: 'test@test.com', password: 'test123', password_confirmation: 'test123')

3.times do |i|
  Artist.create!(name: Faker::Artist.name, biography: Faker::Lorem.paragraphs )
end

Artist.all.each do |artist|
  3.times do |i|
    artist.albums.create!(name: Faker::Lorem.words(rand(4)).join(' '))
  end
end

4000.times do |i|
  featured = [true, false].sample
  featured_text = (featured) ? Faker::Lorem.paragraphs.join(' ') : nil

  Song.create!(artist: Artist.limit(1).order("RANDOM()").last,
               album: Album.limit(1).order("RANDOM()").last,
               name: Faker::Lorem.words(4).join(' '),
               genre_cd: rand(10),
               duration: Faker::Number.decimal(2, 2),
               featured: featured,
               featured_text: featured_text)
end
