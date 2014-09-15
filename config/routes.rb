Rails.application.routes.draw do
  
  root :to => 'static_pages#index'

  devise_for :students,controllers: { sessions: 'students/sessions', registrations: 'students/registrations', passwords:'students/passwords'}
  devise_for :teachers,controllers: { sessions: 'teachers/sessions', registrations: 'teachers/registrations', passwords:'teachers/passwords' }
  resources :bookmarks
  devise_scope :student do
    get "/students" => "students/registrations#index"
  end

  devise_scope :teacher do
    get "/teachers" => "teachers/registrations#index"
  end
  
  get 'answers/accept/:id', to: 'answers#accept', as: :index
  get 'tags/:tag', to: 'questions#index', as: :tag 
  get 'questions/tags', to: 'questions#alltags', as: :tags
  get 'questions/abuse_report/:id',to: 'questions#abuse_report',as: :report
  get '/badges', to: 'badges#index', as: :badges
  resources :tags
  resources :questions do
    resources :comments
    resources :answers
    member { post :vote}
  end
  get '/questions/disable/:id' => 'questions#disable',as: :disable

    resources :comments

  get '/members' => 'members#index'
  get '/members/:id' => 'members#show', as: :member
  get '/members/select_students_manager/:id' => 'members#select_students_manager',as: :select_students_manager

  resources :answers do
    member { post :vote }
    resources :comments
  end

  get 'kyu_mailer/mailer' => 'kyu_mailer#mailer'
end
