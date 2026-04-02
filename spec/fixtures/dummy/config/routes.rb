Dummy::Application.routes.draw do

  resources :pets, only: [:index, :show, :create]

  namespace :admin do
    resources :pets, only: :index
  end
end
