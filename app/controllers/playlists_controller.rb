class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :destroy]

  def index
    @playlists = Playlist.by_user(@current_user.id)
    json_response(@playlists)
  end

  def show
    json_response(@playlist)
  end

  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.user = @current_user
    @playlist.save!

    @playlist.songs << Song.where(id: params[:playlist][:song_ids])

    json_response(@playlist, :created)
  end

  def update
    @playlist.update(playlist_params)

    if params[:playlist][:song_ids].present?
      @playlist.songs.delete
      @playlist.songs << Song.where(id: params[:playlist][:song_ids])
    end

    head :no_content
  end

  def destroy
    @playlist.destroy
    head :no_content
  end

  private

  def playlist_params
    params.require(:playlist).permit(:name) if params[:playlist].present?
  end

  def set_playlist
    @playlist = Playlist.by_user(@current_user.id).find(params[:id])
  end

end
