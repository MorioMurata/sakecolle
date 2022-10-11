Rails.application.routes.draw do


  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    get 'top' => 'homes#top', as: 'top'
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

  scope module: 'public' do
    root to: 'homes#top'
      get 'users/my_page/:id' => 'users#show', as: 'my_page'
      get 'users/information/:id/edit' => 'users#edit'
      patch 'users/information/:id' => 'users#update'
      get 'users/index'
    resources :collections, except: [:index] do
      resources :collection_comments, only: [:create, :destroy]
    end

  end



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
