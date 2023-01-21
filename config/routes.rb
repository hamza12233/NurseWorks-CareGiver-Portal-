Rails.application.routes.draw do

  resources :user_docs do
    get 'search', on: :collection
  end

  resources :paystubs, only: [:index]

  resources :support_requests do
    get 'search', on: :collection
    get :assign_requests
    post :admin_assign_requests
  end

  resources :support_request_types
  namespace :admin do
    resources :users, only: %i[edit update] do
      collection do
        get :new_document_type
        post :create_document_type
      end
    end
  end

  devise_for :users
  resources :users do
    get 'closed_without_docs', on: :collection
    get 'search', on: :collection
  end

  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
