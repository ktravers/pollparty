require "rails_helper"

describe Search do

  describe '#initialize' do
    it "does not raise error when called on with no arguments" do
      expect { Search.new }.to_not raise_error
    end

    it "sets a constant 'base_url' as the root url of the Pollster API" do
      expect(Search::BASE_URL).to eq("http://elections.huffingtonpost.com/pollster/api")
    end

  end

  let (:search) { Search.new }

  describe '#get_url' do 
    it 'accepts one argument, the selected party' do 
      expect { search.get_url('democratic') }.to_not raise_error
    end

    let (:search_gop) { search.get_url('gop') }

    it 'returns a string' do 
      expect(search_gop.class).to eq(String)
    end

    it 'returns a string with the base url
      followed by a slash
      then charts/2016-national-#{party}
      ending with -primary' do 

      regex = /http:\/\/elections.huffingtonpost.com\/pollster\/api\//
      regex_results = [regex.match(search_gop), /-primary/.match(search_gop), /\/charts\/2016-national-gop/.match(search_gop)]
      regex_results.each do |match|
        expect(match).to_not be_nil
      end
    end

    it 'returns the correct url for querying the API' do 
      expect(search_gop).to eq("http://elections.huffingtonpost.com/pollster/api/charts/2016-national-gop-primary")
    end

  end

  describe "#get_json" do
    let(:url) { "http://elections.huffingtonpost.com/pollster/api/charts/2016-national-democratic-primary" }
  
    it 'accepts one argument, a JSON url' do 
      expect { search.get_json(url) }.to_not raise_error
    end

    it 'returns a hash or an array' do 
      type = [Hash, Array]
      expect(search.get_json(url).class).to satisfy{|c| type.include?(c)}
    end

    # it 'is the Ruby Hash version of JSON from a url' do 
    #   expect(search.get_json(url)).to eq(JSON.load(open(url)))
    # end

  end

  describe '#get_leader' do 

    let(:search_democratic) { JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json")) }

    it 'accepts one argument, a hash object' do 
      expect { search.get_leader(search_democratic) }.to_not raise_error
    end

    it 'returns a string' do 
      expect(search.get_leader(search_democratic).class).to eq(String)
    end

    it 'returns the name of the leading candidate' do 
      expect(search.get_leader(search_democratic)).to eq("Clinton")
    end

  end

  describe '#get_standings' do 

    let(:search_democratic) { JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json")) }

    it 'accepts one argument, a hash object' do 
      expect { search.get_standings(search_democratic) }.to_not raise_error
    end

    it 'returns a hash of candidates' do 
      expect(search.get_standings(search_democratic).class).to eq(Hash)
    end

    it 'returns the full name and standing for party candidates' do 
      expect(search.get_standings(search_democratic).keys).to eq(["Clinton", "Biden", "Warren", "Sanders", "O'Malley", "Webb", "Undecided", "Other"])
      expect(search.get_standings(search_democratic).values).to eq([59.7, 12.0, 12.0, 5.4, 1.4, 1.1, 8.0, 3.3])
    end 

  end

  describe '#get_race_url' do 

    let(:search_democratic) { JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json")) }

    it 'accepts one argument, a hash object' do 
      expect { search.get_race_url(search_democratic) }.to_not raise_error
    end

    it 'returns a string' do 
      expect(search.get_race_url(search_democratic).class).to eq(String)
    end

    it 'returns the pollster url for this race' do 
      expect(search.get_race_url(search_democratic)).to eq("http://elections.huffingtonpost.com/pollster/2016-national-democratic-primary")
    end 

  end

  describe '#leader' do 

    it 'accepts one argument, the party' do
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
        end
      end
      expect { search.leader("democratic") }.to_not raise_error
    end

    it 'calls on #get_url, passing it the party' do
      party = 'democratic'
      url = search.get_url(party)
      expect(search).to receive(:get_url).with(party).and_return(url)
      search.leader(party)
    end

    it 'passes #get_json the url that #get_url returns' do 
      party = 'democratic'
      url = search.get_url(party)
      json = search.get_json(url)
      expect(search).to receive(:get_url).with(party).and_return(url)
      expect(search).to receive(:get_json).with(url).and_return(json)
      search.leader(party)
    end

    it 'passes #get_leader the json that #get_json returns' do 
      party = 'democratic'
      url = search.get_url(party)
      json = search.get_json(url)
      leader = search.get_leader(json)
      
      expect(search).to receive(:get_url).with(party).and_return(url)
      expect(search).to receive(:get_json).with(url).and_return(json)
      expect(search).to receive(:get_leader).with(json).and_return(leader)
      search.leader(party)
    end

    it 'returns leading candidate in 2016 democratic primary (as of April 2015)' do 
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
        end
      end
      expect(Search.new.leader('democratic')).to eq("Clinton")
    end

    it 'returns leading candidate in 2016 gop primary (as of April 2015)' do 
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-gop-primary.json"))
        end
      end
      expect(Search.new.leader('gop')).to eq("Jeb Bush")
    end

  end

  describe '#standings' do 

    it 'accepts one argument, the party' do
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
        end
      end
      expect { search.standings("democratic") }.to_not raise_error
    end

    it 'calls on #get_url, passing it the party' do
      party = 'democratic'
      url = search.get_url(party)
      expect(search).to receive(:get_url).with(party).and_return(url)
      search.standings(party)
    end

    it 'passes #get_json the url that #get_url returns' do 
      party = 'democratic'
      url = search.get_url(party)
      json = search.get_json(url)
      expect(search).to receive(:get_url).with(party).and_return(url)
      expect(search).to receive(:get_json).with(url).and_return(json)
      search.standings(party)
    end

    it 'passes #get_standings the json that #get_json returns' do 
      party = 'democratic'
      url = search.get_url(party)
      json = search.get_json(url)
      standings = search.get_standings(json)
      
      expect(search).to receive(:get_url).with(party).and_return(url)
      expect(search).to receive(:get_json).with(url).and_return(json)
      expect(search).to receive(:get_standings).with(json).and_return(standings)
      search.standings(party)
    end

    it 'returns hash of candidates and standings in 2016 democratic primary (as of April 2015)' do 
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
        end
      end
      expect(Search.new.standings('democratic')).to eq({"Clinton"=>59.7, "Biden"=>12.0, "Warren"=>12.0, "Sanders"=>5.4, "O'Malley"=>1.4, "Webb"=>1.1, "Undecided"=>8.0, "Other"=>3.3})
    end

    it 'returns hash of candidates and standings in 2016 gop primary (as of April 2015)' do 
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-gop-primary.json"))
        end
      end
      expect(Search.new.standings('gop')).to eq({"Jeb Bush"=>15.4,"Walker"=>11.9,"Carson"=>8.6,"Huckabee"=>8.5,"Rand Paul"=>7.5,"Cruz"=>6.9,"Christie"=>5.4,"Rubio"=>5.4,"Perry"=>3.0,"Santorum"=>1.7,"Jindal"=>1.5,"Kasich"=>1.3,"Fiorina"=>1.0,"Graham"=>0.8,"Undecided"=>9.0,"Other"=>2.2})
    end

  end

  describe '#url' do 

    it 'accepts one argument, the party' do
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
        end
      end
      expect { search.url("democratic") }.to_not raise_error
    end

    it 'calls on #get_url, passing it the party' do
      party = 'democratic'
      url = search.get_url(party)
      expect(search).to receive(:get_url).with(party).and_return(url)
      search.url(party)
    end

    it 'passes #get_json the url that #get_url returns' do 
      party = 'democratic'
      url = search.get_url(party)
      json = search.get_json(url)
      expect(search).to receive(:get_url).with(party).and_return(url)
      expect(search).to receive(:get_json).with(url).and_return(json)
      search.url(party)
    end

    it 'passes #get_url the json that #get_json returns' do 
      party = 'democratic'
      url = search.get_url(party)
      json = search.get_json(url)
      pollster_url = search.get_url(json)
      
      expect(search).to receive(:get_url).with(party).and_return(url)
      expect(search).to receive(:get_json).with(url).and_return(json)
      expect(search).to receive(:get_race_url).with(json).and_return(pollster_url)
      search.url(party)
    end

    it 'returns pollster url of 2016 democratic primary' do 
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-democratic-primary.json"))
        end
      end
      expect(Search.new.url('democratic')).to eq("http://elections.huffingtonpost.com/pollster/2016-national-democratic-primary")
    end

    it 'returns pollster url of 2016 gop primary' do 
      # stub out get_json method so test can predict result
      class Search
        def get_json(arg)
          JSON.parse( IO.read("spec/support/2016-national-gop-primary.json"))
        end
      end
      expect(Search.new.url('gop')).to eq("http://elections.huffingtonpost.com/pollster/2016-national-gop-primary")
    end

  end

end