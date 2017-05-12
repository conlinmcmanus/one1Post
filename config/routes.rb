Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: %i[get patch], :as => :finish_signup
  resources :posts

  delete '/unlink-twitter', to: 'users#unlink_twitter', as: 'unlink_twitter'
  delete '/unlink-facebook', to: 'users#unlink_facebook', as: 'unlink_facebook'
  delete '/unlink-linkedin', to: 'users#unlink_linkedin', as: 'unlink_linkedin'

  post '/twitter-posts/:id', to: 'posts#twitter_post', as: 'twitter_post'
  post '/facebook-posts/:id', to: 'posts#facebook_post', as: 'facebook_post'
  post '/linkedin-posts/:id', to: 'posts#linkedin_post', as: 'linkedin_post'

  root to: 'home#index'
end
