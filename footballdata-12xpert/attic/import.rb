module Footballdata12xpert


def self.import( *country_keys )
  ## note: always downcase and symbolize keys (thus, allow strings too for now)
  country_keys = country_keys.map {|key| key.downcase.to_sym }

  SOURCES_I.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      import_season_by_season( country_key, country_sources )
    else
      ## skipping country
    end
  end

  SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      import_all_seasons( country_key, country_basename )
    else
      ## skipping country
    end
  end
end # method import


def self.import_season_by_season( country_key, sources )

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, TIMEZONES[country_key]/24.0 ) }

  sources.each do |rec|
    season    =  Season.parse( rec[0] )  ## note: dirname is season_key e.g. 2011-12 etc.
    basenames  = rec[1]                  ## e.g. E1,E2,etc.

    basenames.each do |basename|
      url = season_by_season_url( basename, season )

      ## hack: find a better/easier helper method - why? why not?
      path = "#{Webcache.root}/#{Webcache::DiskCache.new.url_to_path( url )}"
      puts " url: >#{url}<, path: >#{path}<"

      league_key = LEAGUES[basename]  ## e.g.: eng.1, fr.1, fr.2 etc.
      if league_key.nil?
        puts "** !!! ERROR !!! league key missing for >#{basename}<; sorry - please add"
        exit 1
      end

      country_rec, league_rec = find_or_create_country_and_league( league_key )

      season_rec = SportDb::Importer::Season.find_or_create_builtin( season_key )

      matches = CsvMatchReader.read( path, converters: fix_date_converter )

      update_matches_txt( matches,
                            league:  league_rec,
                            season:  season_rec )
    end
  end
end  # method import_season_by_season



def self.import_all_seasons( country_key, basename )

  col  = 'Season'
  path = "#{dir}/#{basename}.csv"

  season_keys = CsvMatchSplitter.find_seasons( path, col: col )
  pp season_keys

  ## note: assume always first level/tier league for now
  league_key = "#{country_key}.1"
  country, league = find_or_create_country_and_league( league_key )

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, FOOTBALLDATA_TIMEZONES[country_key]/24.0 ) }

  season_keys.each do |season_key|
    season = SportDb::Importer::Season.find_or_create_builtin( season_key )

    matches = CsvMatchReader.read( path, filters: { col => season_key },
                                         converters: fix_date_converter )

    pp matches[0..2]
    pp matches.size

    update_matches_txt( matches,
                          league:  league,
                          season:  season )
  end
end  # method import_all_seasons


###
## helper for country and league db record
def self.find_or_create_country_and_league( league_key )
  country_key, level = league_key.split( '.' )
  country = SportDb::Importer::Country.find_or_create_builtin!( country_key )

  league_auto_name = "#{country.name} #{level}"   ## "fallback" auto-generated league name
  pp league_auto_name
  league = SportDb::Importer::League.find_or_create( league_key,
                                                       name:       league_auto_name,
                                                       country_id: country.id )

  [country, league]
end

end ## module Footballdata12xpert
