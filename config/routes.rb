Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: %i[get patch], :as => :finish_signup
  resources :posts

  post '/twitter-post/:id', to: 'posts#send_tweet', as: 'twitter_post'

  devise_scope :user do
    authenticated :user do
      root to: 'posts#index'
    end

    unauthenticated :user do
      root to: 'devise/sessions#new'
    end
  end
end
