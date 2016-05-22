Rails.application.routes.draw do
  mount Mercury::Engine => '/'
  resources :events do
    collection do
      post :push
    end
  end

  mount Spree::Core::Engine, at: '/'
end
