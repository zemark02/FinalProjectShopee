Rails.application.routes.draw do
  resources :products
  resources :stores
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'login' ,to:"main#login"
  post 'login' ,to: 'main#check_valid_login'
  get "feed/:id" ,to: "users#feed"
  get 'favou/:id' , to: "users#showFollow"
  get 'profile/:id' , to: 'users#profile'
  get 'myStore/:id' , to: 'stores#myStore'
  get 'shop/:id' , to: 'stores#showOtherShop'
  post "setFollow" , to: "users#followUpdate"
  get 'product/:id' ,to: "products#showProduct"
  post 'updateCart' ,to: "users#updateCart"
  get 'cart/:id' ,to:"users#cart"
  get 'follow/:id' , to:"users#follow"
  get '/search' , to:"products#search"
  post 'checkout' , to:"users#checkout"
  post 'rate' , to:"products#rate" , as: :rate
  post '/updateProduct' , to:"products#update"
  post '/updateInfo/:id' , to: 'users#updateInfo'
  get '/updateInfo/:id' , to: 'users#profile'
  post '/updateAddress/:id' ,to: 'users#updateAddress'
  get '/updateAddress/:id' , to: 'users#profile'
  post '/updatePassword/:id' ,to: 'users#updatePassword'
  get '/updatePassword/:id' , to: 'users#profile'
  post '/stores/:id' , to:"stores#update"
  post '/delFormCart' ,to:"users#deleteProductFromCart"

end
