require 'rails_helper'
require 'jwt'

RSpec.describe AuthenticationController, type: :api do
  context 'authentication' do
    before do 
      User.create!(name: 'test', email: 'test@test.com', password: 'test123', password_confirmation: 'test123')
    end

    it 'valid user authentication' do
      post "/authenticate", email: "test@test.com", password: 'test123'
      expect(last_response.status).to eq 200
    end

    it 'invalid user authentication' do
      post "/authenticate", email: "test@test.com", password: 'test'
      expect(last_response.status).to eq 401
    end
  end
end
