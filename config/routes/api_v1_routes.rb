# frozen_string_literal: true

module ApiV1Routes
  def self.extended(router)
    router.instance_exec do
      namespace :api, defaults: { format: :json } do
        namespace :v1 do
          devise_for :users, controllers: {
            sessions: 'api/v1/users/sessions',
            registrations: 'api/v1/users/registrations',
          }
          resources :my_links
        end
      end
    end
  end
end
