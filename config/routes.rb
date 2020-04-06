Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "application#hello"
  post "/api/signup" => "user#signup"
  post "/api/login" => "user#login"
  post "/api/create-slot" => "calendar#create_slot"
  post "/api/book-slot" => "calendar#book_slot"
  get "/api/get-slots" => "calendar#get_slots"
  get "/api/get-available-slots" => "calendar#get_available_slots"
  get "/api/get-booked-slots" => "calendar#get_booked_slots"
end
