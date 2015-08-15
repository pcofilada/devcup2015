Rails.application.routes.draw do
  devise_for :users
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:create, :update] do
        resources :channels, only: [:show, :index, :create, :update] do
          resources :announcements, only: [:create]
        end
      end
      resources :sessions, only: [:create, :destroy]
      post 'facebook', to: 'sessions#facebook_login'
      get 'channels', to: 'channels#all_channel'
      get 'channels/:id', to: 'channels#show_channel', as: :channel
      post 'channels/:channel_id/subscriptions', to: 'subscriptions#create', as: 'subscribe'
      put 'channels/:channel_id/subscriptions/:id', to: 'subscriptions#update', as: 'unsubscribe'
    end
  end
end
