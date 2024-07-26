Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_checkts

  # mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :html_documents, only: [:create, :show]
    end
  end
end
