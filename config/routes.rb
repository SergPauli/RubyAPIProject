Rails.application.routes.draw do 
      devise_for :users, controllers: { registrations: 'registrations' }
  get 'authenications/devise'
    devise_scope :user do
      post 'sign_up', to: 'api/auth/registrations#create'
      post 'sign_in', to: 'api/auth/sessions#create'
      delete 'sign_out', to: 'api/auth/sessions#destroy'
      get   'pchange/:id',   to:  'api/auth/passwords#new'
      post 'confirmation', to: 'devise/confirmations#create'
      get 'confirmation', to: 'devise/confirmations#show'
    end    
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :contactstypes
    end
  end
end
