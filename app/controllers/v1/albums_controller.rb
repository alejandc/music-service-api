module V1
  class AlbumsController < ApplicationController
    before_action :set_album, only: [:show, :update, :destroy]

    resource_description do
      formats [:json]
    end

    def_param_group :album do
      param :album, Hash, required: true, desc: 'Album information' do
        param :name, String, required: true, desc: "Name of the album"
        param :artist_id, Integer, required: true, desc: "Artist reference Id"
      end
    end

    api :GET, 'artists/:artist_id/albums', 'Album list by artist'
    error code: 401, desc: "Unauthorized"
    example "albums: [{name: 'Album name', artist_id: :artist_id, image: 'url image', songs: [Song list]}]"
    returns :album, desc: "Album list by artist"
    def index
      @albums = Album.where(artist_id: params[:artist_id])
      json_response(@albums)
    end

    api :GET, 'albums/all', 'Album list'
    error code: 401, desc: "Unauthorized"
    example "albums: [{name: 'Album name', artist_id: :artist_id, image: 'url image', songs: [Song list]}]"
    returns :album, desc: "Album list"
    def all_albums
      @albums = Album.all
      json_response(@albums)
    end

    api :GET, 'albums/:id', 'Show album details'
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    example "album: {name: 'Album name', artist_id: 1, image: 'url image', songs: [Song list]}"
    returns :album, desc: "The album"
    def show
      json_response(@album)
    end

    api :POST, "artists/:artist_id/albums", "Create an album"
    error code: 401, desc: "Unauthorized"
    error code: 422, desc: "Unprocessable Entity"
    description 'Create album with specifed album params'
    param_group :album
    def create
      @album = Album.new(album_params)
      @album.artist = Artist.find(params[:artist_id])

      @album.save!

      json_response(@album, :created)
    end

    api :PUT, "albums/:id", "Update an album"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    error code: 422, desc: "Unprocessable Entity"
    param_group :album
    def update
      @album.update(album_params)
      head :no_content
    end

    api :DELETE, "albums/:id", "Delete an album"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    def destroy
      @album.destroy
      head :no_content
    end

    private

    def album_params
      params.require(:album).permit(:name, :artist_id, :image) if params[:album].present?
    end

    def set_album
      @album = Album.find(params[:id])
    end

  end
end
