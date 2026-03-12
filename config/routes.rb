Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :cast_vote
      delete :cancel_vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers do
      patch :best_answer, on: :member
    end
  end

  resources :answers, only: [], concerns: [:votable]

  resources :badges, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  root to: "questions#index"
end
