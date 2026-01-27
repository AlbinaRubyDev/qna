Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    delete :destroy_file, on: :member

    resources :answers do
      patch :best_answer, on: :member
      delete :destroy_file, on: :member
    end
  end

  root to: "questions#index"
end
