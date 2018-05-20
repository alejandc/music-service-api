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

require 'rails_helper'

RSpec.describe Album, type: :model do
  subject { described_class.new(name: 'album 1', artist: create(:artist)) }

  it { should belong_to(:artist) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without artist" do
      subject.artist = nil
      expect(subject).to_not be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:artist) }
  end
end
