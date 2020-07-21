Rails.application.routes.draw do
    root 'static_pages#home'
    get '/help',  to: 'static_pages#help'
    #signup,login
    get '/signup',  to:'users#new'
    post 'singup', to:'user#create'
    get '/login',  to:'sessions#new'
    post '/login',  to:'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    resources :users
    resources :account_activations, only: %i(edit)
    resources :password_resets, only: %i(new create edit update)
end
