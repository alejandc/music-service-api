require 'rails_helper'
Sidekiq::Testing.fake!

RSpec.describe BulkImportSongsWorker, type: :worker do

  describe 'BulkImportSongsWorker pushed queue' do
    it 'worker queued' do
      expect {
        BulkImportSongsWorker.perform_async([1, 2], 'playlist', 1)
      }.to change(BulkImportSongsWorker.jobs, :size).by(1)
    end
  end

end
