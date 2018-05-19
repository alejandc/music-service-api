# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: 'test2',
                                email: 'test2@test.com',
                                password: 'test123') }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }

    it "is not valid with an invalid email" do
      subject.email = 'invalid_email.com'
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end
  end
end
