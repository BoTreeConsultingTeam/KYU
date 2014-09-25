Rails.application.routes.draw do

  root :to => 'static_pages#index'

  devise_for :students,controllers: { sessions: 'students/sessions', registrations: 'students/registrations', passwords:'students/passwords'}
  devise_for :teachers,controllers: { sessions: 'teachers/sessions', registrations: 'teachers/registrations', passwords:'teachers/passwords' }
  devise_for :administrators,controllers: { sessions: 'administrators/sessions', registrations: 'administrators/registrations'} 
  resources :bookmarks
  devise_scope :student do
    get "/students" => "students/registrations#index"
    get 'student_views_profile/:id' => 'students/registrations#view_profile', as: :student_views_profile
    get 'students/registrations/update_division', to: 'students/registrations#update_division', as: 'update_division'
  end

  devise_scope :teacher do
    get 'teacher_views_profile/:id' => 'teachers/registrations#view_profile', as: :teacher_views_profile
    get "/teachers" => "teachers/registrations#index"
  end
  devise_scope :administrator do
    get "/administrators" => "administrators/sessions#index"
  end

  get 'answers/accept/:id', to: 'answers#accept', as: :index
  get 'questions/abuse_report/:id',to: 'questions#abuse_report',as: :report
  resources :points
  resources :badges
  get 'questions/disabled_questions',to: 'questions#disabled_questions',as: :disabled_questions
  resources :questions do
    collection do
      get 'search_by_keyword'
    end
    resources :comments
    resources :answers
    member { post :vote}
  end

  get 'questions/:tag', to: 'questions#index', as: :search_by_tag
  delete 'tags/:id', to: 'tags#destroy', as: :delete_tag
  resources :tags
  get 'tags/:tag', to: 'questions#index', as: :tag_search
  get '/questions/disable/:id' => 'questions#disable',as: :disable
  get '/questions/enable/:id' => 'questions#enable',as: :enable
  
  resources :comments

  get '/members' => 'members#index'
  get '/members/:id' => 'members#show', as: :member
  get '/members/select_students_manager/:id' => 'members#select_students_manager',as: :select_students_manager
  get 'members/deactivate/:id', to: 'members#deactivate', as: :deactivate
  get 'members/mark_review/:id', to: 'members#mark_review', as: :markreview
  get 'members/unmark_student_review/:id',to: 'members#unmark_student_review',as: :unmark_student_review
  get 'mambers/activate_student/:id',to: 'members#activate_student',as: :activate_student

  resources :answers do
    member { post :vote }
    resources :comments
  end
  
  
  get 'kyu_mailer/mailer' => 'kyu_mailer#mailer'
  get 'reports/class_activity', to: 'reports#class_activity', as: :class_activity
  get 'reports/tags_usage', to: 'reports#tags_usage', as: :tags_usage
  post 'reports/student_weakness', to: 'reports#student_weakness', as: :student_weakness
  post 'reports/student_strength', to: 'reports#student_strength', as: :student_strength
  post 'reports/student_activeness', to: 'reports#student_activeness', as: :student_activeness
  post 'reports/students_questions_compare', to: 'reports#students_questions_compare', as: :students_questions_compare
  post 'reports/students_answers_compare', to: 'reports#students_answers_compare', as: :students_answers_compare
  post 'reports/top_3_weak_area', to: 'reports#top_3_weak_area', as: :top_3_weak_area
  post 'reports/top_3_strong_area', to: 'reports#top_3_strong_area', as: :top_3_strong_area
  get 'reports/update_students', to: 'reports#update_students', as: 'update_students'

  resources :reports
end
