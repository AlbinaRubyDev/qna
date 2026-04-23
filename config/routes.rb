Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

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
  resources :comments, only: :create
  resources :files, only: :destroy
  resources :links, only: :destroy

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
