Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "users#index"

  resources :users, only: [:index, :show] do
    resources :posts, only: [:new, :create, :index, :show, :destroy] do
      resources :comments, only: [:new, :create, :index, :destroy]
      resources :likes, only: [:create]
    end
  end
end
