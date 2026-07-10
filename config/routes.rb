Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health", to: "health#index"

      get "dashboard", to: "dashboard#index"

      resources :funds, only: %i[index show]

      get "reports/portfolio", to: "reports#portfolio"

      get "reports/rankings", to: "reports#rankings"

      get "reports/performance/:fund_id",
          to: "reports#performance"

      get "reports/risk/:fund_id",
          to: "reports#risk"

      resources :rankings, only: :index
      get "forecasts/latest",
          to: "forecasts#latest"

      get "forecasts/:isin",
          to: "forecasts#show"

      resources :forecasts,
                only: [:index]
    end
  end
end