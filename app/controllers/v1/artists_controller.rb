module V1
  class ArtistsController < ApplicationController
    before_action :set_artist, only: [:show, :update, :destroy]

    def index
      @artists = Artist.all
      json_response(@artists)
    end

    def show
      json_response(@artist)
    end

    def create
      @artist = Artist.create!(artist_params)
      json_response(@artist, :created)
    end

    def update
      @artist.update(artist_params)
      head :no_content
    end

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
