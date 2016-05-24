Rails.application.routes.draw do
  get '/editor(/*requested_uri)' => "my_mercury#edit", :as => :mercury_editor
  namespace :mercury do
    resources :images
  end
  mount Mercury::Engine => '/'

  resources :events do
    collection do
      post :push
    end
    member do
      post :up
      post :down
    end
  end
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
