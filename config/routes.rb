Swaggard::Engine.routes.draw do
   get '/(.:format)', to: 'swagger#index', as: :doc
end
