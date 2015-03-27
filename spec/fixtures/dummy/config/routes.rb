Dummy::Application.routes.draw do

  resources :pets, only: [:index, :show]

end