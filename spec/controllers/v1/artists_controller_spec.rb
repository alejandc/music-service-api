require 'rails_helper'

RSpec.describe V1::ArtistsController, type: :request do
  before(:all) do
    generate_user
    @auth_token = login
  end

  let!(:artists) { create_list(:artist, 10) }
  let!(:albums) { create_list(:album, 10, artist: artists.first) }
  let!(:headers) { { 'Content-Type' => 'application/json', 'Authorization' => @auth_token } }

  # Test suite for GET /artists
  describe 'GET /artists' do
    before { get '/artists', {}, headers }

    it 'returns the albums' do
      expect(JSON.parse(last_response.body)).not_to be_empty
      expect(JSON.parse(last_response.body).size).to eq(10)
    end

    it 'returns status code 200' do
      expect(last_response.status).to eq(200)
    end
  end

  # Test suite for GET /artists/:id
  describe 'GET /artists/:id' do
    before { get "/artists/#{artist_id}", {}, headers }

    context 'when the record exists' do
      let(:artist_id) { artists.first.id }

      it 'returns the artist' do
        expect(JSON.parse(last_response.body)).not_to be_empty
        expect(JSON.parse(last_response.body)['id']).to eq(artists.first.id)
      end

      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'when the record does not exist' do
      let(:artist_id) { 1000 }

      it 'returns status code 404' do
        expect(last_response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(last_response.body).to match(/Couldn't find Artist/)
      end
    end
  end

  # Test suite for POST /artists
  describe 'POST /artists' do
    # valid payload
    let(:valid_attributes) { { name: 'Joe', biography: 'artist biography' } }

    context 'when the request is valid' do
      before { post '/artists', { artist: valid_attributes }, headers }

      it 'creates an artist' do
        expect(JSON.parse(last_response.body)['name']).to eq('Joe')
      end

      it 'returns status code 201' do
        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { biography: 'artist biography' } }

      before { post '/artists', { artist: invalid_attributes }, headers }

      it 'returns status code 422' do
        expect(last_response.status).to eq(422)
      end

      it 'returns a validation failure message' do
        expect(last_response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /artists/:id
  describe 'PUT /artists/:id' do
    let(:valid_attributes) { { name: 'Joe' } }

    context 'when the record exists' do
      before { put "/artists/#{artists.first.id}", { artist: valid_attributes }, headers }

      it 'updates the record' do
        expect(last_response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(last_response.status).to eq(204)
      end
    end
  end

  # Test suite for DELETE /artists/:id
  describe 'DELETE /artists/:id' do
    let(:artist_id) { artists.first.id }

    before { delete "/artists/#{artist_id}", {}, headers }

    it 'returns status code 204' do
      expect(last_response.status).to eq(204)
    end

    it 'remove all related albums' do
      expect(Album.by_artist(artist_id).count).to eq(0)
    end
  end
end
