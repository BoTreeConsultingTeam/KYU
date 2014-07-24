KYU::Application.routes.draw do
  root to: 'static_pages#index'

  devise_for :users do
    get '/signin' => 'devise/sessions#new'
    get '/signout' => 'devise/sessions#destroy'
  end
end
