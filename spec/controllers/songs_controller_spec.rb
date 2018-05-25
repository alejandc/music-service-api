require 'rails_helper'

RSpec.describe SongsController, type: :request do
  before(:all) do
    generate_user
    @auth_token = login
  end

  let!(:artist) { create(:artist) }
  let!(:album) { create(:album, artist: artist) }
  let!(:songs) { create_list(:song, 10, artist: artist, album: album) }
  let!(:headers) { { 'Content-Type' => 'application/json', 'Authorization' => @auth_token } }

  # Test suite for GET /albums/:album_id/songs
  describe 'GET /albums/:album_id/songs' do
    before { get "/albums/#{album.id}/songs", {}, headers }

    it 'returns status code 200' do
      expect(JSON.parse(last_response.body)).not_to be_empty
      expect(JSON.parse(last_response.body).size).to eq(10)
      expect(last_response.status).to eq(200)
    end
  end

  # Test suite for GET songs/:id
  describe 'GET /songs/:id' do
    before { get "/songs/#{song_id}", {}, headers }

    context 'when the record exists' do
      let(:song_id) { songs.first.id }

      it 'returns the album' do
        expect(JSON.parse(last_response.body)).not_to be_empty
        expect(JSON.parse(last_response.body)['id']).to eq(songs.first.id)
      end

      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'when the record does not exist' do
      let(:song_id) { 100 }

      it 'returns status code 404' do
        expect(last_response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(last_response.body).to match(/Couldn't find Song/)
      end
    end
  end

  # Test suite for POST /albums/:album_id/songs
  describe 'POST /albums/:album_id/songs' do
    # valid payload
    let(:valid_attributes) { { name: 'Song 1', duration: 189.22, genre_cd: 1,
                               artist_id: artist.id, album_id: album.id } }

    context 'when the request is valid' do
      before { post "/albums/#{album.id}/songs", { song: valid_attributes }, headers }

      it 'creates a todo' do
        expect(JSON.parse(last_response.body)['name']).to eq('Song 1')
      end

      it 'returns status code 201' do
        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { name: nil } }

      before { post "/artists/#{artist.id}/albums", { song: invalid_attributes }, headers }

      it 'returns status code 422' do
        expect(last_response.status).to eq(422)
      end

      it 'returns a validation failure message' do
        expect(last_response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /songs/:id
  describe 'PUT /songs/:id' do
    let(:valid_attributes) { { name: 'Song 2' } }

    context 'when the record exists' do
      before { put "/songs/#{songs.first.id}",
                   { song: valid_attributes }, headers }

      it 'updates the record' do
        expect(last_response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(last_response.status).to eq(204)
      end
    end
  end

  # Test suite for DELETE /songs/:id
  describe 'DELETE /songs/:id' do
    before { delete "/songs/#{songs.first.id}", {}, headers }

    it 'returns status code 204' do
      expect(last_response.status).to eq(204)
    end
  end
end
