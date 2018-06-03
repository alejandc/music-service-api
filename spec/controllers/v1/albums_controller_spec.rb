require 'rails_helper'

RSpec.describe V1::AlbumsController, type: :request do
  before(:all) do
    generate_user
    @auth_token = login
  end

  let!(:artist) { create(:artist) }
  let!(:another_artist) { create(:artist) }
  let!(:albums) { create_list(:album, 10, artist: artist) }
  let!(:another_albums) { create_list(:album, 10, artist: another_artist) }
  let!(:songs) { create_list(:song, 10, artist: artist, album: albums.first) }
  let!(:headers) { { 'Content-Type' => 'application/json', 'Authorization' => @auth_token } }

  # Test suite for GET /artists/:artist_id/albums
  describe 'GET /artists/:artist_id/albums' do
    before { get "/artists/#{artist.id}/albums", {}, headers }

    it 'returns the albums' do
      expect(JSON.parse(last_response.body)).not_to be_empty
      expect(JSON.parse(last_response.body).size).to eq(10)
    end

    it 'returns status code 200' do
      expect(last_response.status).to eq(200)
    end
  end

  # Test suite for GET /albums/all
  describe 'GET /albums/all' do
    before { get "/albums/all", {}, headers }

    it 'returns the albums' do
      expect(JSON.parse(last_response.body)).not_to be_empty
      expect(JSON.parse(last_response.body).size).to eq(20)
    end

    it 'returns status code 200' do
      expect(last_response.status).to eq(200)
    end
  end

  # Test suite for GET /albums/:id
  describe 'GET /albums/:id' do
    before { get "/albums/#{album_id}", {}, headers }

    context 'when the record exists' do
      let(:album_id) { albums.first.id }

      it 'returns the album' do
        expect(JSON.parse(last_response.body)).not_to be_empty
        expect(JSON.parse(last_response.body)['id']).to eq(albums.first.id)
      end

      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'when the record does not exist' do
      let(:album_id) { 100 }

      it 'returns status code 404' do
        expect(last_response.status).to eq(404)
      end

      it 'returns a not found message' do
        expect(last_response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for POST /artists/:artist_id/albums
  describe 'POST /artists/:artist_id/albums' do
    # valid payload
    let(:valid_attributes) { { name: 'Album 1',
                               image: fixture_file_upload(Rails.root.join('spec', 'factories', 'images', 'test_image.jpeg'), 'image/jpeg') } }

    context 'when the request is valid' do
      before { post "/artists/#{artist.id}/albums", { album: valid_attributes }, headers }

      it 'creates an album' do
        expect(JSON.parse(last_response.body)['name']).to eq('Album 1')
        expect(JSON.parse(last_response.body)['image']).to eq('test_image.jpeg')
      end

      it 'returns status code 201' do
        expect(last_response.status).to eq(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { name: nil } }

      before { post "/artists/#{artist.id}/albums", { album: invalid_attributes }, headers }

      it 'returns status code 422' do
        expect(last_response.status).to eq(422)
      end

      it 'returns a validation failure message' do
        expect(last_response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /albums/:id
  describe 'PUT /albums/:id' do
    let(:valid_attributes) { { name: 'Album 2' } }

    context 'when the record exists' do
      before { put "/albums/#{albums.first.id}", { album: valid_attributes }, headers }

      it 'updates the record' do
        expect(last_response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(last_response.status).to eq(204)
      end
    end
  end

  # Test suite for PUT /albums/:id/add_songs
  describe 'PUT /albums/:id/add_songs' do
    let(:album_id) { albums.first.id }
    let(:new_songs) { create_list(:song, 5, artist: artist, album: albums.first) }

    context 'when the record exists' do
      before { put "/albums/#{album_id}/add_songs", { song_ids: new_songs.map(&:id) }, headers }

      it 'returns the playlist' do
        expect(JSON.parse(last_response.body)).not_to be_empty
      end

      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end

    end
  end

  # Test suite for PUT /albums/:id/remove_songs
  describe 'PUT /albums/:id/remove_songs' do
    let(:album_id) { albums.first.id }

    context 'when the record exists' do
      before { put "/albums/#{album_id}/remove_songs", { song_ids: songs.last(5).map(&:id) }, headers }

      it 'returns the playlist' do
        expect(JSON.parse(last_response.body)).not_to be_empty

        expect(Album.includes(:songs).find(album_id).songs.count).to eq(5)
      end

      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end

    end
  end

  # Test suite for DELETE /albums/:id
  describe 'DELETE /albums/:id' do
    let(:album_id) { albums.first.id }

    before { delete "/albums/#{album_id}", {}, headers }

    it 'returns status code 204' do
      expect(last_response.status).to eq(204)
    end

    it 'remove all related songs' do
      expect(Song.by_album(album_id).count).to eq(0)
    end
  end
end
