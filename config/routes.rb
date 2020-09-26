Rails.application.routes.draw do
    devise_scope :user do
      post 'sign_up', to: 'users/registrations#create'
      post 'confirmation', to: 'devise/confirmations#create'
      get 'confirmation', to: 'devise/confirmations#show'
    end
    devise_for :users, skip: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :contactstypes
    end
  end
end
