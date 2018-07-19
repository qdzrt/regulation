Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  get '/not_found', to: 'welcome#not_found', as: 'not_found'
  get '/sign_up', to: 'users#new', as:  'sign_up'
  get '/sign_in', to: 'sessions#new', as:  'sign_in'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'

  delete '/delete_attachment', to: 'attachments#destroy', as: 'delete_attachment'

  namespace :admin do
    resources :roles
    resources :users do
      member do
        delete 'del_images'
      end
    end
    resources :products
    resources :credit_evals
    resources :loan_fees
  end

  resources :users, except: [:index, :destroy] do
    member do
      delete 'del_images'
    end
  end

  resources :loan_fees, only: [:index] do
    collection do
      get 'seckill'
    end
  end

  mount API => '/'
  if Rails.env.development?
    mount GrapeSwaggerRails::Engine => '/docs'
  end

  match '*path', to: 'welcome#not_found', via: :all

end
