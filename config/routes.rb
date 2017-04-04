Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
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
