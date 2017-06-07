Rails.application.routes.draw do
  root 'welcome#index'

  get 'sessions/new'
  post '/login' => 'sessions#create'
  get 'sessions/destroy'

  namespace :admin do
    resources :users
   end
end
