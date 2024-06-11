
## todo/fix: move CsvMatchWriter to its own file!!!!!
class CsvMatchWriter

  def self.write( path, matches )

    headers = [
      'Date',
      'Team 1',
      'FT',
      'HT',
      'Team 2'
    ]


    ## note - write to (string/memory) buffer first
    buf = String.new
    buf << headers.join(',')   ## e.g. Date,Team 1,FT,HT,Team 2
    buf << "\n"


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

      buf << values.join( ',' )
      buf << "\n"
    end


 
    ## for convenience - make sure parent folders/directories exist
    FileUtils.mkdir_p( File.dirname( path) )  unless Dir.exist?( File.dirname( path ))

    puts
    puts "==> #{path}..."
    puts buf

    ## try with universal newline support (only use \n and not \r\n)
    ##  keep file same on windows and unix
    ##   not working really with universal 
    ## out = File.new( path, 'w:utf-8', universal: true )
    ##
    ##   note -  that ^M and \r are the same.
    ##
    ## todo/fix - use a string buffer (buf)
    ##  and than use 
    ##    str.gsub( /\r\n?/, "\n" ) 
    ##
    ##  retry with some later year
    ##   plus check if write_text in cocos is using universal newline or such?

    ## write as binary (to avoid windows new line issue/ auto-conversion??)
    ##   "b"  Binary file mode
    ##    Suppresses EOL <-> CRLF conversion on Windows. And
    ## File.open( path, 'wb' ) do |f|
    ##  change to binary - why? why not?
    ##
    #  for git diff/config always use - why? why not?
    #
    # git config --global core.autocrlf false
    # git config --global core.eol lf
  
    File.open( path, 'w:utf-8' ) do |f| 
      f.write( buf )
    end
  end  # method self.write
end # class CsvMatchWriter



module Footballdata12xpert

##
## todo/fix: add fix_date converter to CsvReader !!!!!

def self.convert( *country_keys, start: nil, 
                                 stop:  nil )
  ## note: always downcase and symbolize keys (thus, allow strings too for now)
  country_keys = country_keys.map {|key| key.downcase.to_sym }

  SOURCES_I.each do |country_key, country_sources|
    if country_keys.empty? || country_keys.include?( country_key )
      convert_season_by_season( country_key,
                                country_sources,
                                  start: start,
                                  stop:  stop )
    else
      ## skipping country
    end
  end

  SOURCES_II.each do |country_key, country_basename|
    if country_keys.empty? || country_keys.include?( country_key )
      convert_all_seasons( country_key,
                           country_basename,
                             start: start,
                             stop:  stop )
    else
      ## skipping country
    end
  end
end  ## method convert


###
# private helpers / machinery

def self.convert_season_by_season( country_key, sources,
                                        start: nil,
                                        stop:  nil )

  start = Season.parse( start )   if start  ## convert to season obj
  stop  = Season.parse( stop )    if stop

  sources.each do |rec|
    season     = Season.parse( rec[0] )   ## note: dirname is season e.g. 2011-12 etc.
    basenames  = rec[1]   ## e.g. E1,E2,etc.

    if start && season < start
      puts "skipping #{season} before start #{start}"
      next
    end

    if stop && season > stop
      puts " - skipping #{season} after stop #{stop}"
      next
    end

    basenames.each do |basename|
      url = season_by_season_url( basename, season )

      ## hack: find a better/easier helper method - why? why not?
      in_path = "#{Webcache.root}/#{Webcache::DiskCache.new.url_to_path( url )}"
      puts " url: >#{url}<, in_path: >#{in_path}<"

      league_key = LEAGUES[basename]
      league_basename = league_key   ## e.g.: eng.1, fr.1, fr.2 etc.

      out_path = "#{config.convert.out_dir}/#{season.to_path}/#{league_basename}.csv"

      puts "out_path: #{out_path}"

      matches = SportDb::CsvMatchParser.read( in_path )
      puts "#{matches.size} matches"
      exit 1   if matches.size == 0   ## make sure parse works (don't ignore empty reads)


      CsvMatchWriter.write( out_path, matches )
    end
  end
end # method convert_season_by_season



def self.convert_all_seasons( country_key, basename, 
                                start: nil,
                                stop:  nil )

  start = Season.parse( start )   if start  ## convert to season obj
  stop  = Season.parse( stop )    if stop    ## convert to season obj


  url = all_seasons_url( basename )

  ## hack: find a better/easier helper method - why? why not?
  in_path = "#{Webcache.root}/#{Webcache::DiskCache.new.url_to_path( url )}"
  puts " url: >#{url}<, in_path: >#{in_path}<"

  col  = 'Season'
  season_keys = SportDb::CsvMatchParser.find_seasons( in_path, col: col )
  pp season_keys

  ## todo/check: make sure timezones entry for country_key exists!!! what results with nil/24.0 ??
  fix_date_converter = ->(row) { fix_date( row, TIMEZONES[country_key]/24.0 ) }

  season_keys.each do |season_key|
    season = Season.parse( season_key )
    if start && season < start
      puts "skipping #{season} before start #{start}"
      next
    end
    if stop && season > stop
      puts " - skipping #{season} after stop #{stop}"
      next
    end


    matches = SportDb::CsvMatchParser.read( in_path, filters: { col => season_key },
                                                     converters: fix_date_converter )

    pp matches[0..2]
    pp matches.size

    ## note: assume (always) first level league for now
    league_basename = "#{country_key}.1"    ## e.g.: ar.1, at.1, mx.1, us.1, etc.

    out_path = "#{config.convert.out_dir}/#{season.to_path}/#{league_basename}.csv"

    CsvMatchWriter.write( out_path, matches )
  end
end

end # module Footballdata12xpert
