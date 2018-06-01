module V1
  class SongsController < ApplicationController
    before_action :set_song, only: [:show, :update, :destroy, :set_featured]

    resource_description do
      formats [:json]
    end

    def_param_group :song do
      param :song, Hash, required: true, desc: 'Song information' do
        param :name, String, required: true, desc: "Name of the song"
        param :duration, Float, required: true, desc: "Duration of the song"
        param :genre_cd, Integer, required: true, desc: "Genre of the Song"
        param :featured, [true|false], required: false, desc: "Song featured"
        param :featured_text, String, required: false, desc: "Text for the featured Song"
        param :artist_id, Integer, required: true, desc: "Artist reference Id"
        param :album_id, Integer, required: true, desc: "Album reference Id"
      end
    end

    api :GET, 'albums/:album_id/songs', 'Songs list by album'
    error code: 401, desc: "Unauthorized"
    example "songs: [{name: 'Song name', duration: 90, genre: 'Rock', featured: [true|false],
                      featured_text: 'Text', artis_id: 1, album_id: 1, image: 'URL image'}]"
    returns :song, desc: "Song list"
    def index
      @songs = Song.by_album(params[:album_id])
      json_response(@songs)
    end

    api :GET, 'songs/search', 'Search songs by name'
    error code: 401, desc: "Unauthorized"
    example "songs: [{name: 'Song name', duration: 90, genre: 'Rock', featured: [true|false],
                      featured_text: 'Text', artis_id: 1, album_id: 1, image: 'URL image'}]"
    returns :song, desc: "Search songs by name"
    def search
      @songs = SongSearcher.search(params)
      json_response(@songs)
    end

    api :GET, 'songs/:id', 'Show song details'
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    example "song: {name: 'Song name', duration: 90, genre: 'Rock', featured: [true|false],
                    featured_text: 'Text', artis_id: 1, album_id: 1, image: 'URL image'}"
    returns :song, desc: "The song"
    def show
      json_response(@song)
    end

    api :POST, "albums/:album_id/songs", "Create a song"
    error code: 401, desc: "Unauthorized"
    error code: 422, desc: "Unprocessable Entity"
    description 'Create song with specifed song params'
    param_group :song
    def create
      @song = Song.new(song_params)

      @album = Album.includes(:artist).find(params[:album_id])
      @song.album = @album
      @song.artist = @album.artist

      @song.save!

      json_response(@song, :created)
    end

    api :PUT, "songs/:id", "Update a song"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    error code: 422, desc: "Unprocessable Entity"
    param_group :song
    def update
      @song.update(song_params)
      head :no_content
    end

    api :DELETE, "songs/:id", "Delete a song"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    def destroy
      @song.destroy
      head :no_content
    end

    api :PUT, "songs/:id", "Set songs as featured"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    param :featured_text, String, desc: 'Text info about featured song'
    param :image, File, desc: 'Image for song featured'
    def set_featured
      @song.update(featured: true, featured_text: song_params[:featured_text])
      @song.image.attach(song_params[:image])
      head :no_content
    end

    private

    def song_params
      params.require(:song).permit(:name, :duration, :genre_cd, :artist_id,
                                   :album_id, :image, :featured, :featured_text) if params[:song].present?
    end

    def set_song
      @song = Song.find(params[:id])
    end

  end
end
