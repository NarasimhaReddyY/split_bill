Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboard#index"

  resources :groups do
    resources :transactions, only: [:new, :edit, :create, :update]
    get :transaction_summary, on: :member
  end

  resources :transactions, only: [:show]
end
