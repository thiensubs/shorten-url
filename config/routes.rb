Rails.application.routes.draw do
  apipie
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get '/:slug', to: 'home#show', as: :point_now
  scope '/short' do
    resources :my_links
  end
  ###---API v1---
  extend ApiV1Routes
  ###---End API v1---
end
