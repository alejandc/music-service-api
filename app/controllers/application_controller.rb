class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  include Response
  include ExceptionHandler

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def start_songs_bulk_import(song_ids, import_origin, import_id)
    BulkImportSongsWorker.perform_async(song_ids, import_origin, import_id)
  end

end
