
## todo/fix: move CsvMatchWriter to its own file!!!!!
class CsvMatchWriter

  def self.write( path, matches )

    ## for convenience - make sure parent folders/directories exist
    FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exist?( File.dirname( path ))


    out = File.new( path, 'w:utf-8' )

    headers = [
      'Date',
      'Team 1',
      'FT',
      'HT',
      'Team 2'
    ]

    out << headers.join(',')   ## e.g. Date,Team 1,FT,HT,Team 2
    out << "\n"


    matches.each_with_index do |match,i|

      if i < 2
         puts "[#{i}]:" + match.inspect
      end

      ## note: skip empty match rows
      ##   todo/fix:   fix "upstream" in match parser!!!!!
      next if match.team1.blank? && match.team2.blank?


      values = []

      ## note:
      ##   as a convention add all auto-calculated values in ()
      ##  e.g. weekday e.g. (Fri), weeknumber (22), matches played (2), etc.

      ## for easier double-checking of rounds and dates
      ##  (auto-)add weekday and weeknumber
      ##  todo/fix: weeknumber - use +1  (do NOT start with 0 - why? why not)
      if match.date
        ## todo/fix: add time if present? why? why not?
        ## note: assumes string for now e.g. 2018-11-22
        date = Date.strptime( match.date, '%Y-%m-%d' )

        date_buf = ''
        date_buf << date.strftime( '%a %b %-d %Y' )
        ## date_buf << " (W#{date.cweek})"  ## use week number (iso-standard week starting on monday)

        values << date_buf   ## print weekday e.g. Fri, Sat, etc.
      else
        values << '?'
      end



      values << match.team1

      if match.score1 && match.score2
        values << "#{match.score1}-#{match.score2}"
      else
        # no (or incomplete) full time score; add empty
        values << '?'
      end

      if match.score1i && match.score2i
        values << "#{match.score1i}-#{match.score2i}"
      else
        # no (or incomplete) half time score; add empty
        values << '?'
      end

      values << match.team2

      out << values.join( ',' )
      out << "\n"
    end

    out.close
  end
end # class CsvMatchWriter




module Footballdata

##
## todo/fix: add fix_date converter to CsvReader !!!!!


def self.convert_season_by_season( country_key, sources,
                                     start: nil,
                                     normalize: false )

  start = Season.parse( start )   if start  ## convert to season obj


  out_dir = './o'


  sources.each do |rec|
    season     = Season.parse( rec[0] )   ## note: dirname is season e.g. 2011-12 etc.
    basenames  = rec[1]   ## e.g. E1,E2,etc.

    if start && season < start
      puts "skipping #{season} before #{start}"
      next
    end

    basenames.each do |basename|
      url = season_by_season_url( basename, season )

      ## hack: find a better/easier helper method - why? why not?
      in_path = "#{Webcache.root}/#{Webcache::DiskCache.new.url_to_path( url )}"
      puts " url: >#{url}<, in_path: >#{in_path}<"

      league_key = FOOTBALLDATA_LEAGUES[basename]
      league_basename = league_key   ## e.g.: eng.1, fr.1, fr.2 etc.

      out_path = "#{out_dir}/#{season.to_path}/#{league_basename}.csv"

      puts "out_path: #{out_path}"

      matches = SportDb::CsvMatchParser.read( in_path )
      puts "#{matches.size} matches"
      exit 1   if matches.size == 0   ## make sure parse works (don't ignore empty reads)


      normalize_clubs( matches, country_key )  if normalize

      CsvMatchWriter.write( out_path, matches )
    end
  end
end # method convert_season_by_season



def self.convert_all_seasons( country_key, basename,
                                   start: nil,
                                   normalize: false )

  start = Season.parse( start )   if start  ## convert to season obj

  out_dir = './o'

  url = all_seasons_url( basename )

  ## hack: find a better/easier helper method - why? why not?
  in_path = "#{Webcache.root}/#{Webcache::DiskCache.new.url_to_path( url )}"
  puts " url: >#{url}<, in_path: >#{in_path}<"

  col  = 'Season'
  season_keys = SportDb::CsvMatchParser.find_seasons( in_path, col: col )
  pp season_keys

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, FOOTBALLDATA_TIMEZONES[country_key]/24.0 ) }

  season_keys.each do |season_key|
    season = Season.parse( season_key )
    if start && season < start
      puts "skipping #{season} before #{start}"
      next
    end

    matches = SportDb::CsvMatchParser.read( in_path, filters: { col => season_key },
                                                     converters: fix_date_converter )

    pp matches[0..2]
    pp matches.size

    ## note: assume (always) first level league for now
    league_basename = "#{country_key}.1"    ## e.g.: ar.1, at.1, mx.1, us.1, etc.

    out_path = "#{out_dir}/#{season.to_path}/#{league_basename}.csv"

    normalize_clubs( matches, country_key )  if normalize

    CsvMatchWriter.write( out_path, matches )
  end
end



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


end # module Footballdata
