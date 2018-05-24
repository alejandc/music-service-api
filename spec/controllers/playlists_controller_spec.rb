require 'rails_helper'

RSpec.describe PlaylistsController, type: :request do
  before(:all) do
    @user = generate_user
    @auth_token = login
  end

  let!(:artist) { create(:artist) }
  let!(:album) { create(:album) }
  let!(:songs) { create_list(:song, 10, artist: artist, album: album) }
  let!(:playlists) { create_list(:playlist, 10, songs: songs, user: @user) }
  let!(:headers) { { 'Content-Type' => 'application/json', 'Authorization' => @auth_token } }

  # Test suite for GET /playlists
  describe 'GET /playlists' do
    before { get '/playlists', {}, headers }

    it 'returns status code 200' do
      expect(JSON.parse(last_response.body)).not_to be_empty
      expect(JSON.parse(last_response.body).size).to eq(10)
      expect(last_response.status).to eq(200)
    end
  end

  # Test suite for GET /playlists/:id
  describe 'GET /playlists/:id' do
    before { get "/playlists/#{playlist_id}", {}, headers }

    context 'when the record exists' do
      let(:playlist_id) { playlists.first.id }

      it 'returns the playlists' do
        expect(JSON.parse(last_response.body)).not_to be_empty
        expect(JSON.parse(last_response.body)['id']).to eq(playlists.first.id)
      end

      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'when the record does not exist' do
      let(:playlist_id) { 100 }

      it 'returns status code 404' do
        expect(last_response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(last_response.body).to match(/Couldn't find Playlist/)
      end
    end
  end

  # Test suite for POST /playlists
  describe 'POST /playlists' do
    # valid payload
    let(:valid_attributes) { { name: 'Playlist 1', song_ids: songs.map(&:id)  } }

    context 'when the request is valid' do
      before { post '/playlists', { playlist: valid_attributes }, headers }

      it 'creates a todo' do
        expect(JSON.parse(last_response.body)['name']).to eq('Playlist 1')
        expect(JSON.parse(last_response.body)['songs'].count).to eq(songs.count)
      end

      it 'returns status code 201' do
        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { name: nil } }

      before { post '/playlists', { playlist: invalid_attributes }, headers }

      it 'returns status code 422' do
        expect(last_response.status).to eq(422)
      end

      it 'returns a validation failure message' do
        expect(last_response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /playlists/:id
  describe 'PUT /playlists/:id' do
    let(:valid_attributes) { { name: 'Playlist 2' } }

    context 'when the record exists' do
      before { put "/playlists/#{playlists.first.id}", { playlist: valid_attributes }, headers }

      it 'updates the record' do
        expect(last_response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(last_response.status).to eq(204)
      end
    end
  end

  # Test suite for DELETE /playlists/:id
  describe 'DELETE /playlists/:id' do
    before { delete "/playlists/#{playlists.first.id}", {}, headers }

    it 'returns status code 204' do
      expect(last_response.status).to eq(204)
    end
  end
end
