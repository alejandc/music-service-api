class BulkImportSongsWorker
  include Sidekiq::Worker

  def perform(song_id_list, import_origin, import_id)
    if import_origin.eql?('playlist')
      playlist = Playlist.find_by_id(import_id)
      model.songs << Song.where(id: song_id_list) if playlist.present?
    elsif import_origin.eql?('album')
      album = Album.find_by_id(import_id)
      Song.where(id: song_id_list).update_all(album: album) if album.present?
    else
      raise 'Bulk Import not defined'
    end
  end

end
