require "rails_helper"

RSpec.describe SearchController do

  describe 'GET show' do
    before(:all) { get :show, :commit => 'democratic' }

    # it 'assigns @party' do 
    #   expect(@party).to eq('democratic')
    # end

    # xit 'assigns @leader' do 
    #   leader = Search.new.leader(@party)
    #   expect(@leader).to eq(leader)
    # end

    # xit 'assigns @standings' do 
    #   standings = Search.new.standings(@party)
    #   expect(@standings).to eq(standings)
    # end

    # xit 'assigns @url' do 
    #   url = Search.new.url(@party)
    #   expect(@url).to eq(url)
    # end

    # xit "should render 'show' page if get request includes params[:commit]" do 
    #   expect(response).to render_template(:show)
    # end
  end
end