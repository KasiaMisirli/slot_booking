Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "slots#index"
  get "slots", controller: "slots", action: "index"
  put "slots", controller: "slots", action: "update"
end
