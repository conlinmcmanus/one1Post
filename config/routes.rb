Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get '/users/:id/finish_signup', to: 'users#finish_signup'
  patch '/users/:id/finish_signup', to: 'users#finish_signup'
  resources :posts

  devise_scope :user do
    authenticated :user do
      root to: 'posts#index'
    end

    unauthenticated :user do
      root to: 'devise/sessions#new'
    end
  end 
end
