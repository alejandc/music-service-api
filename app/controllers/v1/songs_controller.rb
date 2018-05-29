module V1
  class SongsController < ApplicationController
    before_action :set_song, only: [:show, :update, :destroy, :set_featured]

    def index
      @songs = Song.by_album(params[:album_id])
      json_response(@songs)
    end

    def search
      @songs = SongSearcher.search(params)
      json_response(@songs)
    end

    def show
      json_response(@song)
    end

    def create
      @song = Song.new(song_params)

      @album = Album.includes(:artist).find(params[:album_id])
      @song.album = @album
      @song.artist = @album.artist

      @song.save!

      json_response(@song, :created)
    end

    def update
      @song.update(song_params)
      head :no_content
    end

    def destroy
      @song.destroy
      head :no_content
    end

    def set_featured
      @song.update(featured: true, featured_text: song_params[:featured_text])
      @song.image.attach(song_params[:images])
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
