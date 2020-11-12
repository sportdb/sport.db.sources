####
#  helper for normalize clubs
def self.normalize_clubs( matches, country_key )
  country_key = country_key.to_s  ## note: club struct uses string (not symbols); make sure we (always) use strings (otherwise compare fails)
  cache = {}   ## note: use a (lookup) cache for matched club names

  country = SportDb::Import.config.countries[ country_key ]
  ## todo/fix: assert country NOT nil / present

  matches.each do |match|
    names = [match.team1, match.team2]
    clubs = []     # holds the match club 1 and club 2 (that is, team 1 and team 2)
    names.each do |name|
      club = cache[name]
      if club   ## bingo! found cached club match/entry
        clubs << club
      else
        club = SportDb::Import.config.clubs.find_by( name: name, country: country )
        if club.nil?
          ## todo/check: exit if no match - why? why not?
          puts "!!! *** ERROR *** no matching club found for >#{name}, #{country_key}< - add to clubs setup"
          exit 1
        end
        cache[name] = club   ## cache club match
        clubs << club
      end
    end # each name
    ## update names to use canonical names
    match.update( team1: clubs[0].name,
                  team2: clubs[1].name )
  end # each match
end  # method normalize_clubs
