require 'rails_helper'

RSpec.describe "Searches", type: :request do
  describe "GET /search/suggestions" do
    before do
      Search.create(search_text: "Best RPG games 2024")
      Search.create(search_text: "Most played multiplayer games")
    end

    it "returns matching suggestions" do
      get search_suggestions_path, params: { term: "Best" }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to include("Best RPG games 2024")
      expect(json).not_to include("Most played multiplayer games")
    end
  end
end

RSpec.describe "Articles search", type: :request do
  let!(:article) { Article.create(title: "Best RPG games 2024") }

  it "returns articles matching the query" do
    get search_results_path, params: { query: "RPG" }
    expect(response).to have_http_status(:success)
    expect(response.body).to include(article.title)
  end

  it "saves the most complete query only" do
    expect {
      get search_results_path, params: { query: "Best" }
      get search_results_path, params: { query: "Best RPG" }
      get search_results_path, params: { query: "Best RPG games 2024" }
    }.to change(Search, :count).by(1)

    expect(Search.last.search_text).to eq("Best RPG games 2024")
  end

  it "does not create duplicates" do
    Search.create(search_text: "Best RPG games 2024")

    expect {
      get search_results_path, params: { query: "Best RPG games 2024" }
    }.not_to change(Search, :count)
  end
end
