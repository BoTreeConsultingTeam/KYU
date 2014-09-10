Rails.application.routes.draw do
  
  root :to => 'static_pages#index'

  devise_for :students,controllers: { sessions: 'students/sessions', registrations: 'students/registrations', passwords:'students/passwords'}
  devise_for :teachers,controllers: { sessions: 'teachers/sessions', registrations: 'teachers/registrations', passwords:'teachers/passwords' }

  devise_scope :student do
    get "/students" => "students/registrations#index"
  end

  devise_scope :teacher do
    get "/teachers" => "teachers/registrations#index"
  end
  
  get 'answers/accept/:id', to: 'answers#accept', as: :index
  resources :tags
  
  resources :questions do
    resources :comments
    resources :answers
    member { post :upvote,:downvote }
  end
  get 'questions/:tag', to: 'questions#index', as: :search_by_tag
  delete 'tags/:id', to: 'tags#destroy', as: :delete_tag
  
  resources :comments

  get '/members' => 'members#index'
  get '/members/:id' => 'members#show', as: :member

  resources :answers do
    member { post :upvote,:downvote }
    resources :comments
  end
end
