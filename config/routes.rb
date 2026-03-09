Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :cast_vote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable]  do
      patch :best_answer, on: :member
    end
  end

  resources :badges, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  root to: "questions#index"
end
