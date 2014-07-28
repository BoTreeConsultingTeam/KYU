KYU::Application.routes.draw do
  root to: 'static_pages#index'

  devise_for :users
  resources :admin
  resources :operators
  resources :teachers

  resources :users do
    collection do
      post :create_member
    end
  end
end
