require "rails_helper"

describe SearchController do

  let (:search) { Search.new }

  describe 'GET /search' do
    
    it 'responds with status ok' do
      get :show
      expect(response.status).to eq(200)
    end

    describe "when user selects democratic donkey" do
      before { get :show, :commit => 'democratic' }

      it 'knows the party selected by the user' do 
        expect(controller.params[:commit]).to eq('democratic')
      end

      it 'sets @party to user selected party' do
        party = controller.params[:commit]
        expect(assigns[:party]).to eq(party)
      end

      it 'sets @leader to leading candidate (as of April 2015)' do
        # stub out get_json method so test can predict result
        class Search
          def get_json(arg)
            JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
          end
        end 
        expect(assigns[:leader]).to eq("Clinton")
      end  

      it 'sets @standings to hash of candidates and standings (as of April 2015)' do
        # stub out get_json method so test can predict result
        class Search
          def get_json(arg)
            JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
          end
        end 
        expect(assigns[:standings]).to eq({"Clinton"=>59.7, "Biden"=>12.0, "Warren"=>12.0, "Sanders"=>5.4, "O'Malley"=>1.4, "Webb"=>1.1, "Undecided"=>8.0, "Other"=>3.3})
      end 

      it 'sets @url to Pollster url of 2016 democratic primary' do
        # stub out get_json method so test can predict result
        class Search
          def get_json(arg)
            JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
          end
        end 
        expect(assigns[:url]).to eq("http://elections.huffingtonpost.com/pollster/2016-national-democratic-primary")
      end 

      it "renders 'show' page" do 
        expect(response).to render_template(:show)
      end

    end
  end
    
  describe '#search_params' do
    it 'cleans the params' do
      params = ActionController::Parameters.new(search: {"commit"=>'gop', "foo"=>'bar'})
      search_params = params.require(:search).permit(:commit)
      expect(search_params).to eq({"commit"=>'gop'})
    end
  end  
    
end