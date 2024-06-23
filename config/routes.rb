Rails.application.routes.draw do
  get 'contacts/new'
  get 'contacts/confirm'
  get 'contacts/done'
  devise_for :users


  root to: "homes#top"
  get "home/about" => "homes#about"
  get "search" => "searches#search"
  delete 'book/:id' => 'books#destroy', as: 'destroy_book'

  resources :books
  resources :users

  resources :books, only: [:new, :create, :index, :show, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
end

  resources :contacts, only: [:new, :create] do
  collection do
      post 'confirm'
      post 'back'
      get 'done'
  end
end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
end
