Rails.application.routes.draw do
  namespace :admin, path: 'cadmin' do
    resources :events
    resources :images
    resources :pages

    root to: 'events#index'
  end

  resources :events

  get '/about' => 'about#index'
  put '/about' => 'about#update'
  get '/payment' => 'payment#index'
  put '/payment' => 'payment#update'
  get '/delivery' => 'delivery#index'
  put '/delivery' => 'delivery#update'
  get '/return' => 'return#index'
  put '/return' => 'return#update'
  get '/contacts' => 'contacts#index'
  put '/contacts' => 'contacts#update'

  mount Spree::Core::Engine, at: '/'
end
