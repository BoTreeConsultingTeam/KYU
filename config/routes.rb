Rails.application.routes.draw do
  
  
  root :to => 'static_pages#index'

  devise_for :students,controllers: { sessions: 'students/sessions', registrations: 'students/registrations', passwords:'students/passwords'}
  devise_for :teachers,controllers: { sessions: 'teachers/sessions', registrations: 'teachers/registrations', passwords:'teachers/passwords' }
  devise_for :administrators,controllers: { sessions: 'administrators/sessions', registrations: 'administrators/registrations', passwords:'administrators/passwords' }
  devise_scope :student do
    get "/students" => "students/registrations#index"
  end

  devise_scope :teacher do
    get "/teachers" => "teachers/registrations#index"
  end

  devise_scope :administrator do
    get "/administrators" => "administrators/sessions#index"
  end

  get 'answers/accept/:id', to: 'answers#accept', as: :index
  get 'tags/:tag', to: 'questions#index', as: :tag 
  get 'questions/tags', to: 'questions#alltags', as: :tags

  resources :tags
  resources :questions do
    resources :comments
    resources :answers
    member { post :upvote,:downvote }
  end
    resources :comments

  get '/members' => 'members#index'
  get '/members/:id' => 'members#show', as: :member
  get 'members/deactivate/:id', to: 'members#deactivate', as: :deactivate

  resources :answers do
    member { post :upvote,:downvote }
    resources :comments
  end
end
