Rails.application.routes.draw do

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
    resources :users, only: [:index, :show, :destroy]
    resources :collections, except: [:index] do
      resources :collection_comments, only: [:index, :destroy]
    end
  end


  # 顧客用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    confirmations: "public/confirmations",
    mailer: "public/mailer",
    passwords: "public/passwords",
    registrations: "public/registrations",
    sessions: 'public/sessions',
    shared: "public/shared",
    unlocks: "public/unlock"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: 'public' do
    root to: 'homes#top'
    resources :users, except: [:new, :create] do
      get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
      patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
      resource :relationships, only: [:create, :destroy]
      get :follows, on: :member
      get :followers, on: :member
      get :favorites, on: :member
    end
    resources :collections do
      resources :collection_comments, only: [:index, :create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end

  end



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
