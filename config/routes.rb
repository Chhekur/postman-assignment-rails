Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "application#hello"
  post "/signup" => "user#signup"
  post "/login" => "user#login"
  post "/hehe" => "user#hehe"
  post "/create-slot" => "calendar#create_slot"
  post "/book-slot" => "calendar#book_slot"
  get "/get-slots" => "calendar#get_slots"
  get "/get-available-slots" => "calendar#get_available_slots"
  get "/get-booked-slots" => "calendar#get_booked_slots"
end
