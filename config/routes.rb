Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers do
      patch :best_answer, on: :member
    end
  end

  resources :badges, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  root to: "questions#index"
end
