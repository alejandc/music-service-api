module SongSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mappings dynamic: 'strict' do
      indexes :id, type: 'integer'
      indexes :name, type: 'text'
      indexes :duration, type: 'float'
      indexes :genre_cd, type: 'integer'
      indexes :genre, type: 'text'
      indexes :artist_id, type: 'integer'
      indexes :artist_name, type: 'text'
      indexes :album_id, type: 'integer'
      indexes :album_name, type: 'text'
      indexes :featured, type: 'boolean'
      indexes :featured_text, type: 'text'
    end

    def as_indexed_json(opts = {})
      {
        id: self.id,
        name: self.name,
        duration: self.duration,
        genre_cd: self.genre_cd,
        genre: self.genre.to_s,
        artist_id: self.artist_id,
        album_id: self.album_id,
        featured: self.featured,
        featured_text: featured_text
      }
    end

  end
end
