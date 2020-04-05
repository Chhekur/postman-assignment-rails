Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "application#hello"
  post "/signup" => "user#signup"
  post "/login" => "user#login"
end
