Rails.application.routes.draw do
  root 'welcome#index'

  get 'sessions/new'
  post '/login' => 'sessions#create'
  get 'sessions/destroy'

  resources :users, only: [:edit, :update]

  namespace :admin do
    resources :users, except: [:show]
   end
end
