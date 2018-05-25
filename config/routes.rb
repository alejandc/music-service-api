Rails.application.routes.draw do

  post 'authenticate', to: 'authentication#authenticate'

  get 'songs/all', to: 'songs#all_songs'

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
