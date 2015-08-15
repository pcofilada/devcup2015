Rails.application.routes.draw do
  devise_for :users
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: :create do
        resources :channels, only: [:show, :index, :create, :update] do
          resources :announcements, only: [:create]
        end
      end
      resources :sessions, only: [:create, :destroy]
      post 'facebook', to: 'sessions#facebook_login'
      get :channels, to: 'channels#all_channel'
    end
  end
end
