Rails.application.routes.draw do

  resources :teams

  resources :feedbacks
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get 'team_view/help', to: 'teams#help'
  get 'regenerate_admin_code', to: 'options#regenerate_admin_code'
  get 'reset_password', to: 'static_pages#show_reset_password'
  post 'reset_password', to: 'static_pages#reset_password'
        
  get 'teams/:id/confirm_delete_user_from_team', to: 'teams#confirm_delete_user_from_team', as: 'team_confirm_delete_delete_user_from_team'  
  get 'teams/:id/confirm_delete', to: 'teams#confirm_delete', as: 'team_confirm_delete'
  resources :teams 
  
  get 'users/:id/confirm_delete', to: 'users#confirm_delete', as: 'user_confirm_delete'
  get 'users/:id/reset_user_password', to: 'users#reset_user_password', as: 'reset_user_password'

  
  get    '/login',  to: 'sessions#new'    
  post   '/login',  to: 'sessions#create'    
  get    '/logout', to: 'sessions#destroy' 
  get '/signup', to: 'users#new'
  
  resources :users, except: [:new]

  resources :teams do
    post :remove_user_from_team
  end  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end


