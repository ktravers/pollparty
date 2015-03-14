class SearchController < ApplicationController

  def index
    # params = {"utf8"=>"✓", "commit"=>"Democrat"}
    if params[:commit]
      @party = params[:commit]
      @leader = Search.leader(@party)
      @polls = Search.polls(@party)
      render 'show'
    end
  end

  private
    def search_params
      params.require(:search).permit(:commit)
    end

end
