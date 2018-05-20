require 'rails_helper'

RSpec.describe ArtistsController, type: :request do
  let!(:artists) { create_list(:artist, 10) }
  let(:auth_token) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MjY4MjU2NTl9.W7jOPb0mlCNpKlJvlglfP4-jBMBh_YUSkjpt-Xhv4K0' }

  # Test suite for GET /artists
  describe 'GET /artists' do
    before { get '/artists', headers: { 'Content-Type' => 'application/json',
                                        'Authorization' => auth_token } }

    it 'returns status code 200' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /artists/:id
  describe 'GET /artists//:id' do
    before { get "/artists/#{artist_id}", headers: { 'Content-Type' => 'application/json',
                                                     'Authorization' => auth_token } }

    context 'when the record exists' do
      let(:artist_id) { artists.first.id }

      it 'returns the artist' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(artists.first.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:artist_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Artist/)
      end
    end
  end

  # Test suite for POST /artists
  describe 'POST /artists' do
    # valid payload
    let(:valid_attributes) { { name: 'Joe', biography: 'artist biography' } }

    context 'when the request is valid' do
      before { post '/artists', { params: valid_attributes.to_json,
                                  headers: { 'Content-Type' => 'application/json',
                                             'Authorization' => auth_token } } }

      it 'creates a todo' do
        expect(JSON.parse(response.body)['name']).to eq('Joe')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { biography: 'artist biography' } }

      before { post '/artists', { params: invalid_attributes.to_json,
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

  # Test suite for PUT /artists/:id
  describe 'PUT /artists/:id' do
    let(:valid_attributes) { { name: 'Joe' } }

    context 'when the record exists' do
      before { put "/artists/#{artists.first.id}", params: valid_attributes.to_json,
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

  # Test suite for DELETE /artists/:id
  describe 'DELETE /artists/:id' do
    before { delete "/artists/#{artists.first.id}", headers: {'Content-Type' => 'application/json',
                                                              'Authorization' => auth_token } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
