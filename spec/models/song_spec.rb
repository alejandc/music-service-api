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

require 'rails_helper'

RSpec.describe Song, type: :model do
  subject { described_class.new(name: 'album 1', duration: 10.22, artist: create(:artist),
                                album: (create(:album)), genre_cd: 1) }

  it { should belong_to(:artist) }
  it { should belong_to(:album) }
  it { should have_and_belong_to_many(:playlists) }

  describe 'Album image' do
    let(:song_image) { create(:featured_song).image }

    it 'album image saved' do
      expect(song_image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe 'Featured songs' do
    let!(:featured_songs) { create_list(:featured_song, 5) }

    it 'featured songs saved' do
      expect(Song.featured(true).count).to eq(featured_songs.count)
    end
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:artist) }
    it { should validate_presence_of(:album) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:genre) }
  end
end
