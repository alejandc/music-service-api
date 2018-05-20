require 'rails_helper'

RSpec.describe AlbumsController, type: :request do
  before(:all) { create(:user) }
  let!(:artist) { create(:artist) }
  let!(:albums) { create_list(:album, 10, artist: artist) }
  let(:auth_token) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MjY4MjU2NTl9.W7jOPb0mlCNpKlJvlglfP4-jBMBh_YUSkjpt-Xhv4K0' }

  # Test suite for GET /artists/#{artist.id}/albums
  describe 'GET /artists/:artist_id/albums' do
    before { get "/artists/#{artist.id}/albums", headers: { 'Content-Type' => 'application/json',
                                                            'Authorization' => auth_token } }

    it 'returns status code 200' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /artists/#{artist.id}/albums/:id
  describe 'GET /artists/:artist_id/albums/:id' do
    before { get "/artists/#{artist.id}/albums/#{album_id}", headers: { 'Content-Type' => 'application/json',
                                                                        'Authorization' => auth_token } }

    context 'when the record exists' do
      let(:album_id) { albums.first.id }

      it 'returns the album' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(albums.first.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:album_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for POST /artists/#{artist.id}/albums
  describe 'POST /artists/:artist_id/albums' do
    # valid payload
    let(:valid_attributes) { { name: 'Album 1' } }

    context 'when the request is valid' do
      before { post "/artists/#{artist.id}/albums", { params: valid_attributes.to_json,
                                                      headers: { 'Content-Type' => 'application/json',
                                                                 'Authorization' => auth_token } } }

      it 'creates a todo' do
        expect(JSON.parse(response.body)['name']).to eq('Album 1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { name: nil } }

      before { post "/artists/#{artist.id}/albums", { params: invalid_attributes.to_json,
                                  headers: {'Content-Type' => 'application/json',
                                            'Authorization' => auth_token } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /artists/#{artist.id}/albums/:id
  describe 'PUT /artists/:artist_id/albums/:id' do
    let(:valid_attributes) { { name: 'Album 2' } }

    context 'when the record exists' do
      before { put "/artists/#{artist.id}/albums/#{albums.first.id}", params: valid_attributes.to_json,
                                                 headers: {'Content-Type' => 'application/json',
                                                           'Authorization' => auth_token } }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /artists/#{artist.id}/albums/:id
  describe 'DELETE /artists/:artist_id/albums/:id' do
    before { delete "/artists/#{artist.id}/albums/#{albums.first.id}", headers: {'Content-Type' => 'application/json',
                                                            'Authorization' => auth_token } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
