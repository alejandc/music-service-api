class SongsController < ApplicationController
  before_action :set_song, only: [:show, :update, :destroy]

  def index
    @songs = Song.by_artist(params[:artist_id]).by_album(params[:album_id])
    json_response(@songs)
  end

  def show
    json_response(@song)
  end

  def create
    @song = Song.new(song_params)
    @song.artist = Artist.find(params[:artist_id])
    @song.album = Album.find(params[:album_id])

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

  private

  def song_params
    params.require(:song).permit(:name, :duration, :genre_cd, :artist_id,
                                 :album_id) if params[:song].present?
  end

  def set_song
    @song = Song.find(params[:id])
  end

end