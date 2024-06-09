module Footballdata12xpert


def self.download( *country_keys, start: nil )   ## download all datasets (all leagues, all seasons)
  ## note: always downcase and symbolize keys (thus, allow strings too for now)
  country_keys = country_keys.map {|key| key.downcase.to_sym }

  SOURCES_I.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      download_season_by_season( country_sources, start: start )
    else
      ## skipping country
    end
  end

  SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      download_all_seasons( country_basename )
    else
      ## skipping country
    end
  end
end  ## method download



###
# private helpers / machinery

## note:
##  switch base_url to https!!!
##    http no longer supported!!!
BASE_URL = 'https://www.football-data.co.uk'

def self.season_by_season_url( basename, season )
  # build short format e.g. 2008/09 becomes 0809
  #                         2019/20 becomes 1920 etc.
  season_path = "%02d%02d" % [season.start_year % 100, season.end_year % 100]
  # note: add "magic" mmz4281/ directory to base_url
  "#{BASE_URL}/mmz4281/#{season_path}/#{basename}.csv"
end

def self.all_seasons_url( basename )
  # note: add new/ directory  to base_url
  "#{BASE_URL}/new/#{basename}.csv"
end



def self.download_season_by_season( sources, start: nil )   ## format i - one datafile per season
  start = Season.parse( start )   if start  ## convert to season obj

  sources.each do |rec|
    season     = Season.parse( rec[0] )   ## note: dirname is season_key e.g. 2011-12 etc.
    basenames  = rec[1]

    if start && season < start
      puts "skipping #{season} before #{start}"
      next
    end

    basenames.each do |basename|
      url = season_by_season_url( basename, season )
      get( url )
    end
  end
end

def self.download_all_seasons( basename )   ## format ii - all-seasons-in-one-datafile
  url = all_seasons_url( basename )
  get( url )
end



#############
# helpers
def self.get( url )
  ## [debug] GET=http://www.football-data.co.uk/mmz4281/0405/SC0.csv
  ##    Encoding::UndefinedConversionError: "\xA0" from ASCII-8BIT to UTF-8
  ##     note:  0xA0 (160) is NBSP (non-breaking space) in Windows-1252

  ## note: assume windows encoding (for football-data.uk)
  ##   use "Windows-1252" for input and convert to utf-8
  ##
  ##    see https://www.justinweiss.com/articles/3-steps-to-fix-encoding-problems-in-ruby/
  ##    see https://en.wikipedia.org/wiki/Windows-1252

  response = Webget.dataset( url, encoding: 'Windows-1252' )

  ## note: exit on get / fetch error - do NOT continue for now - why? why not?
  exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
end

end # module Footballdata12xpert
