Swaggard::Engine.routes.draw do
   get '/doc', to: 'swagger#doc'

   get '/api', to: 'swagger#index'
   get '/api/*resource', to: 'swagger#show'
end