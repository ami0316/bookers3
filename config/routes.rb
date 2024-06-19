Rails.application.routes.draw do
  devise_for :users


  root to: "homes#top"
  get "home/about" => "homes#about"
  get "search" => "searches#search"
  delete 'book/:id' => 'books#destroy', as: 'destroy_book'

  resources :books
  resources :users
  resources :books, only: [:new, :create, :index, :show, :destroy] do
    resources :post_comments, only: [:create, :destroy]
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
end
