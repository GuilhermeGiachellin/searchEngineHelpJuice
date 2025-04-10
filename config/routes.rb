Rails.application.routes.draw do
  get "search", to: "searches#index", as: :search
  get "search/results", to: "searches#results", as: :search_results
  get "search/suggestions", to: "searches#suggestions", as: :search_suggestions

  root "searches#index"
end