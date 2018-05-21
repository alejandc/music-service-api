Rails.application.routes.draw do

  post 'authenticate', to: 'authentication#authenticate'

  resources :artists do
    resources :albums do
      resources :songs
    end
  end

  resources :playlists

end
