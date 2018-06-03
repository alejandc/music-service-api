module V1
  class PlaylistsController < ApplicationController
    before_action :set_playlist, only: [:show, :update, :destroy, :empty, :add_songs,
                                        :remove_songs]
    after_action only: [:index] { set_pagination_header(:playlists) }

    resource_description do
      formats [:json]
    end

    def_param_group :playlist do
      param :playlist, Hash, required: true, desc: 'Playlist information' do
        param :name, String, required: true, desc: "Name of the playlist"
        param :user_id, String, required: true, desc: "User Id reference"
      end
    end

    api :GET, 'playlists', 'Playlists by user'
    error code: 401, desc: "Unauthorized"
    example "playlists: [{name: 'Playlist name', songs: [Song list]}]"
    returns :playlist, desc: "Playlists by user"
    def index
      @playlists = Playlist.includes(:songs).by_user(@current_user.id).page(params[:page])
      json_response(@playlists)
    end

    api :GET, 'playlists/:id', 'Show playlist details'
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    example "playlist: {name: 'Playlist name', songs: [Song list]}"
    returns :playlist, desc: "The playlist"
    def show
      json_response(@playlist)
    end

    api :POST, "playlists", "Create a playlist"
    error code: 401, desc: "Unauthorized"
    error code: 422, desc: "Unprocessable Entity"
    description 'Create playlist with specifed playlist params'
    param_group :playlist
    def create
      @playlist = Playlist.new(playlist_params)
      @playlist.user = @current_user
      @playlist.save!

      @playlist.songs << Song.where(id: params[:playlist][:song_ids])

      json_response(@playlist, :created)
    end

    api :PUT, "playlists/:id", "Update a playlist"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    error code: 422, desc: "Unprocessable Entity"
    param_group :playlist
    def update
      @playlist.update(playlist_params)
      head :no_content
    end

    api :DELETE, "playlists/:id", "Delete a playlist"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    def destroy
      @playlist.destroy
      head :no_content
    end

    api :PUT, "playlists/:id/empty", "Empty playlist"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    def empty
      @playlist.songs.delete_all
      head :no_content
    end

    api :PUT, "playlists/:id/add_songs", "Add songs to the playlist"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    param :song_ids, Array, desc: "List of song ids to add to playlist"
    description "This functionality is processed in background mode, the user will" \
                " be notified when the process finish. The returned value represent" \
                " the process reference to check the process status."
    example "{'process_reference': '123'}"
    def add_songs
      job_id = start_songs_bulk_import(params[:song_ids], 'playlist', @playlist.id)
      json_response({process_reference: job_id})
    end

    api :PUT, "playlists/:id/remove_songs", "Remove songs from the playlist"
    error code: 401, desc: "Unauthorized"
    error code: 404, desc: "Not Found"
    param :song_ids, Array, desc: "List of song ids to remove from playlist"
    def remove_songs
      if params[:song_ids].present?
        songs_to_remove = Song.where(id: params[:song_ids])
        @playlist.songs.delete(songs_to_remove)
      end

      json_response(@playlist)
    end

    private

    def playlist_params
      params.require(:playlist).permit(:name) if params[:playlist].present?
    end

    def set_playlist
      @playlist = Playlist.by_user(@current_user.id).find(params[:id])
    end

  end
end
