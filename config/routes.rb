Rails.application.routes.draw do
  resources :events do
    collection do
      post :push
    end
  end

  mount Spree::Core::Engine, at: '/'
end
