Rails.application.routes.draw do
  resources :inquiries, only: [:create]
end
