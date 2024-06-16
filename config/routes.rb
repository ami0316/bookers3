Rails.application.routes.draw do
  devise_for :users


  root to: "homes#top"
  get "home/about" => "homes#about"
  get "search" => "searches#search"
  delete 'book/:id' => 'books#destroy', as: 'destroy_book'

  resources :books
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
