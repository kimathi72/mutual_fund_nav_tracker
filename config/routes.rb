Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health", to: "health#index"

      get "dashboard", to: "dashboard#index"

      resources :funds, only: %i[index show]
      resources :rankings, only: :index
      resources :forecasts, only: %i[index show]
      get "forecasts/latest", to: "forecasts#latest"
      get "reports/briefing", to: "reports#briefing"
      namespace :ml do
        post "forecasts/bulk", to: "forecasts#bulk"
        patch "forecasts/score", to: "forecasts#score"
        get "forecasts/unscored", to: "forecasts#unscored"
      end
        # get "reports/portfolio", to: "reports#portfolio"

        # get "reports/rankings", to: "reports#rankings"

        # get "reports/performance/:fund_id",
        #     to: "reports#performance"

        # get "reports/risk/:fund_id",
        #     to: "reports#risk"

        # get "forecasts/latest",
        #     to: "forecasts#latest"

        # get "forecasts/:isin",
        #     to: "forecasts#show"

        # post "forecasts/bulk", to: "forecasts#bulk"


        # resources :forecasts,
        #             only: [:index]
    end
  end
end