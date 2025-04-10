class SearchesController < ApplicationController
  def index
    
  end

  def suggestions
    term = params[:term]
  
    suggestions = if term.present?
      Search.where("search_text ILIKE ?", "%#{term}%")
            .select(:search_text)
            .distinct
            .limit(5)
            .pluck(:search_text)
    else
      []
    end
  
    render json: suggestions
  end

  def results
    @query = params[:query]&.strip
  
    if @query.present?      
      Search.where("LENGTH(search_text) < LENGTH(?)", @query)
            .where("? ILIKE search_text || '%'", @query)
            .delete_all  
      
      Search.find_or_create_by(search_text: @query)
  
      @results = Article.where("title ILIKE :q", q: "%#{@query}%")
    else
      @results = []
    end
  end
  
end
