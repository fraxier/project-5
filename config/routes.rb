Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  ### Custom Routes
  post '/login',    to: 'sessions#login'
  post '/logout',   to: 'sessions#destroy'
  get '/logged_in', to: 'sessions#is_logged_in?'

  get '/recent_learnings/:num', to: 'learnings#recent'
  get '/recent_learnings', to: 'learnings#recent'

  get '/mega_summary', to: 'sessions#mega_summary'
  patch '/learnings/tag', to: 'learnings#remove_tag'
  patch '/learnings/add_tags', to: 'learnings#add_tags'

  # resources :user, only: %i[index show create update] do
  #   resources :subject, only: %i[index show create update destroy] do
  #     resources :topic, only: %i[index show create destroy] do
  #       resources :note, only: %i[index show create update destroy]
  #       resources :resource, only: %i[index show create update destroy]
  #     end
  #   end
  # end
  resources :users, only: %i[index show create update]
  resources :tags, only: %i[index show create destroy]
  resources :learnings, only: %i[index show create update destroy]
  resources :headings, only: %i[index show create destroy]
  resources :notes, only: %i[index show create update destroy]
  resources :resources, only: %i[index show create update destroy]
end
