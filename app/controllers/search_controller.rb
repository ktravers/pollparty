class SearchController < ApplicationController

  def index
    # params = {"utf8"=>"✓", "commit"=>"democratic"}
    if params[:commit]
      @party = params[:commit]
      @leader = Search.new.leader(@party)
      @standings = Search.new.standings(@party)
      render 'show'
    end
  end

  private
    def search_params
      params.require(:search).permit(:commit)
    end

end
