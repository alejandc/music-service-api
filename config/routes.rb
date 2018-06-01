Rails.application.routes.draw do

  apipie
  post 'authenticate', to: 'authentication#authenticate'

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    get 'songs/search', to: 'songs#search'
    get 'albums/all', to: 'albums#all_albums'

    resources :artists, shallow: true do
      resources :albums do
        resources :songs do
          member do
            put 'set_featured'
          end
        end
      end
    end

    resources :playlists do
      member do
        put 'empty'
        put 'add_songs'
        put 'remove_songs'
      end
    end
  end

end
