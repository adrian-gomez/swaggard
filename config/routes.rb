Swaggard::Engine.routes.draw do
   get '/(.:format)', to: 'swagger#index'
end