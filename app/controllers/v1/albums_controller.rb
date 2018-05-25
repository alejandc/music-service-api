module V1
  class AlbumsController < ApplicationController
    before_action :set_album, only: [:show, :update, :destroy]

    def index
      @albums = Album.where(artist_id: params[:artist_id])
      json_response(@albums)
    end

    def show
      json_response(@album)
    end

    def create
      @album = Album.new(album_params)
      @album.artist = Artist.find(params[:artist_id])

      @album.save!

      json_response(@album, :created)
    end

    def update
      @album.update(album_params)
      head :no_content
    end

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
