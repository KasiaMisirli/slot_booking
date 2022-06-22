Rails.application.routes.draw do
  resources :slots
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "slots#index"
  get "slots", controller: "slots", action: "index"
end
