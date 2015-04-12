class Search

  BASE_URL = "http://elections.huffingtonpost.com/pollster/api"

  def get_url(party)
    "#{BASE_URL}/charts/2016-national-#{party}-primary"
  end
  # => "http://elections.huffingtonpost.com/pollster/api/charts/2016-national-democratic-primary"

  def get_json(url)
    JSON.load(open(url))
  end

  def get_leader(pollster_hash)
    pollster_hash["estimates"].first["choice"]
  end

  def get_standings(pollster_hash)
    c_hash = {}
    pollster_hash["estimates"].collect do |candidate|
      c_hash[candidate["choice"]] = candidate["value"]
    end
    c_hash
  end

  def get_race_url(pollster_hash)
    pollster_hash["url"]
  end

  def leader(party)
    url = get_url(party)
    pollster_hash = get_json(url)
    get_leader(pollster_hash)
  end

  def standings(party)
    url = get_url(party)
    pollster_hash = get_json(url)
    get_standings(pollster_hash)
  end

  def url(party)
    url = get_url(party)
    pollster_hash = get_json(url)
    get_race_url(pollster_hash)
  end

end