module V1
  class ArtistsController < ApplicationController
    before_action :set_artist, only: [:show, :update, :destroy]

    resource_description do
      formats [:json]
    end

    def_param_group :artist do
      param :artist, Hash, required: true, desc: 'Artist information' do
        param :name, String, required: true, desc: "Name of the artist"
      end
    end

    api :GET, 'artists', 'Artist list'
    error :code => 401, :desc => "Unauthorized"
    example "artists: [{name: 'Artist name', albums: [Album list], songs: [Song list]}]"
    returns :artist, :desc => "Artist list"
    def index
      @artists = Artist.all
      json_response(@artists)
    end

    api :GET, 'artists/:id', 'Show artist details'
    error :code => 401, :desc => "Unauthorized"
    error :code => 404, :desc => "Not Found"
    example "artist: {name: 'Artist name', albums: [Album list], songs: [Song list]}"
    returns :artist, :desc => "The artist"
    def show
      json_response(@artist)
    end

    api :POST, "artists", "Create an artist"
    error :code => 401, :desc => "Unauthorized"
    error :code => 422, :desc => "Unprocessable Entity"
    description 'Create artist with specifed artist params'
    param_group :artist
    def create
      @artist = Artist.create!(artist_params)
      json_response(@artist, :created)
    end

    api :PUT, "artists/:id", "Update an artist"
    error :code => 401, :desc => "Unauthorized"
    error :code => 404, :desc => "Not Found"
    error :code => 422, :desc => "Unprocessable Entity"
    param_group :artist
    def update
      @artist.update!(artist_params)
      head :no_content
    end

    api :DELETE, "artists/:id", "Delete an artist"
    error :code => 401, :desc => "Unauthorized"
    error :code => 404, :desc => "Not Found"
    def destroy
      @artist.destroy
      head :no_content
    end

    private

    def artist_params
      params.require(:artist).permit(:name) if params[:artist].present?
    end

    def set_artist
      @artist = Artist.find(params[:id])
    end

  end
end
