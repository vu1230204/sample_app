Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users#, only: %i(new create)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
