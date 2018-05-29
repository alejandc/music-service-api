require 'elasticsearch/rails/tasks/import'

desc 'Elasticsearch tasks'
namespace :elasticsearch do
  desc 'Reacreate indexes and import documents'
  task :recreate_index => :environment do
    delete_index
    create_index

    Song.includes(:artist, :album).import
  end

  desc 'Create all indexes'
  task :create_index => :environment do
    create_index
  end

  desc 'Delete all indexes'
  task :delete_index => :environment do
    delete_index
  end

  def create_index
    song_mappings = Song.mappings.to_hash

    Song.__elasticsearch__.client.indices.create \
      index: Song.index_name,
      body: { settings: {index: {number_of_shards: 1, max_result_window: 10000}},
              mappings: song_mappings }
  end

  def delete_index
    Song.__elasticsearch__.client.indices.delete index: Song.index_name rescue nil
  end
end
