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
  scope 'api/v1/universal_api/:model_name', controller: 'api/v1/universal_api' do
    post '/', action: 'index'
    post '/:id', action: 'show'
    post '/add', action: 'create'
    put '/:id', action: 'update'
    delete '/:id', action: 'destroy'
  end
end
