Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get '/orders/:id' => 'orders#getById'
  post '/orders' => 'orders#create'
  get '/orders' => 'orders#get'
end
