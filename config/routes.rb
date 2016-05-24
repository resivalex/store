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

  mount Spree::Core::Engine, at: '/'
end
