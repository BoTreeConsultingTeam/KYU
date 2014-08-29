Rails.application.routes.draw do
  root :to => 'static_pages#index'

  devise_for :students,controllers: { sessions: 'students/sessions', registrations: 'students/registrations', passwords:'students/passwords'}
  devise_for :teachers,controllers: { sessions: 'teachers/sessions', registrations: 'teachers/registrations', passwords:'teachers/passwords' }
  root :to => 'static_pages#index'
 
  devise_scope :student do
    get "/students" => "students/registrations#index"
    get "/students/:id/edit" => "students/registrations#edit"
  end
  devise_scope :teacher do
    get "/teachers" => "teachers/registrations#index"
  end

  resources :questions do 
    resources :comments
  end
  resources :comments

  resources :answers do
    resources :comments
  end

  get 'tags/:tag', to: 'questions#index', as: :tag
  get 'answers/accept/:id', to: 'answers#accept', as: :index

   # Add a custom sign in route for user sign in
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  resources :tags
  resources :questions do
    resources :answers
    member { post :upvote,:downvote }
  end
  get 'questions/:tag' => 'questions#index',as: :show
  get '/members' => 'members#index'
  get '/members/:id' => 'members#show', as: :member

  resources :answers do
    member { post :upvote,:downvote }
  end
end
