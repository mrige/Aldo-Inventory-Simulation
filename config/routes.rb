Rails.application.routes.draw do
  resources :stores
  resources :shoes
  resources :shoes do
    member do
        patch :transfer
        put :transfer
      end
  end
  root to: "shoes#inventory"
end