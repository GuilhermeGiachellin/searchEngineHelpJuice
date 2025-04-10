Rails.application.routes.draw do
  get "search", to: "searches#index", as: :search
  get "search/results", to: "searches#results", as: :search_results

  root "searches#index"
end