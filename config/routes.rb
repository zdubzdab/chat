Rails.application.routes.draw do
  root 'mailbox#inbox'
  get 'mailbox/sent' => 'mailbox#sent', as: :mailbox_sent

  get 'sessions/new'
  post 'sessions/create'
  get 'sessions/destroy'

  get 'conversations/refresh_unread_messages' =>
    'conversations/refresh_unread_messages'

  resources :users, only: [:edit, :update]

  resources :conversations do
    member do
      post :reply
    end
  end

  namespace :admin do
    resources :users, except: [:show]
   end
end
