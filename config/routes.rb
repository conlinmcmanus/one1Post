Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: %i[get patch], :as => :finish_signup
  resources :posts

  delete '/unlink-twitter', to: 'posts#unlink_twitter', as: 'unlink_twitter'
  delete '/unlink-facebook', to: 'posts#unlink_facebook', as: 'unlink_facebook'
  delete '/unlink-linkedin', to: 'posts#unlink_linkedin', as: 'unlink_linkedin'

  post '/twitter-posts/:id', to: 'posts#send_tweet', as: 'twitter_post'
  post '/facebook-posts/:id', to: 'posts#send_fbpost', as: 'facebook_post'
  post '/linkedin-posts/:id', to: 'posts#send_linkedin_post', as: 'linkedin_post'

  devise_scope :user do
    authenticated :user do
      root to: 'posts#index'
    end

    unauthenticated :user do
      root to: 'devise/sessions#new'
    end
  end
end
