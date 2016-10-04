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

  get '/yandexkassa/:gateway_id/:order_number' => 'spree/yandexkassa#show', as: :yandexkassa
  get '/yandexkassa/success_payment' => 'spree/yandexkassa#success_payment', as: :success_payment
  get '/yandexkassa/failed_payment' => 'spree/yandexkassa#failed_payment', as: :failed_payment

  # Временно
  get '/yandexkassa/success_order' => 'spree/yandexkassa#success_payment'
  get '/yandexkassa/failed_order' => 'spree/yandexkassa#failed_payment'

  post '/yandexkassa/check_order' => 'spree/yandexkassa#check_order'
  post '/yandexkassa/payment_aviso' => 'spree/yandexkassa#payment_aviso'

  # Временно
  match '/yandexkassa/aviso_order' => 'spree/yandexkassa#payment_aviso', via: [:get, :post]

  post '/yandexkassa/test_check_order' => 'spree/yandexkassa#check_order'
  post '/yandexkassa/test_payment_aviso' => 'spree/yandexkassa#payment_aviso'
end
