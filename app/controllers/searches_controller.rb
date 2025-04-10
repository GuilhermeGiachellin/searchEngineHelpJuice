class SearchesController < ApplicationController
  def index
    
  end

  def results
    @query = params[:query]

    if @query.present?      
      @results = Article.where("title ILIKE :q", q: "%#{@query}%")
    else
      @results = []
    end
  end
end
