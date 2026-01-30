Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers do
      patch :best_answer, on: :member
    end
  end

  resources :files, only: :destroy

  root to: "questions#index"
end
