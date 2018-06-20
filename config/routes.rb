Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  get '/sign_in', to: 'sessions#new', as:  'sign_in'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'

  resources :users
  resources :products

  mount API => '/'
  if Rails.env.development?
    mount GrapeSwaggerRails::Engine => '/docs'
  end

end
