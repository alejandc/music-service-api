Rails.application.routes.draw do

  post 'authenticate', to: 'authentication#authenticate'

  resources :artists, shallow: true do
    resources :albums do
      resources :songs
    end
  end

  resources :playlists do
    member do
      put 'empty'
      put 'add_songs'
    end
  end

end
