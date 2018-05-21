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
    @playlist = Playlist.create!(playlist_params)
    #TODO pending relation with song list
    json_response(@playlist, :created)
  end

  def update
    @playlist.update(playlist_params)
    #TODO pending relation with song list
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
    @playlist = Playlist.find(params[:id])
  end

end
