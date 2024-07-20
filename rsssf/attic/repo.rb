
## used by Repo#make_schedules
ScheduleConfig = Struct.new(
  :name,
  :opts_for_year,  ## hash or proc ->(year){ Hash[...] }
  :dir_for_year,  ## proc ->(year){ 'path_here'}     ## rename to path_for_year - why, why not??
  :includes        ## array of years to include e.g. [2011,2012] etc.
)


ScheduleStat = Struct.new(
  :path,          ## e.g. 2012-13 or archive/1980s/1984-85
  :filename,      ## e.g. 1-bundesliga.txt   -- note: w/o path
  :year,          ## e.g. 2013      -- note: numeric (integer)
  :season,        ## e.g. 2012-13   -- note: is a string
  :rounds         ## e.g. 36   -- note: numeric (integer)
)



def make_schedules_summary_v0( stats )   ## note: requires stats to be passed in for now
    report = ScheduleReport.new( stats, @opts )   ## pass in title etc.
    report.save( "#{@repo_path}/README.md" )
end  # method make_schedules_summary
  



def each_page_v0( &blk )  ## use each table or such - why? why not?
  cfg = YAML.load_file( "#{@repo_path}/tables/config.yml") 
  pp cfg

  cfg.each do |key,line|

    ## e.g.       tablesb/braz2013.html  --  Windows-1252
    ##        or  tablesb/braz2014.html  !! Windows-1252
    values = line.split( /--|!!/ ).map { |value| value.strip }
    path = values[0]

    ## note: assumes extension is .html
    #    e.g. tablesd/duit2011.html => duit2011
    basename = File.basename( path, '.html' )

    path = "#{@repo_path}/tables/#{basename}.txt"

     ## convert key to season
     season = Season( key )

     page = Page.from_file( path )

     blk.call( season, page )
  end 
end


def fetch_pages( start: nil, stop: nil )
  ## start, stop (season) -- allows to limit processing

  puts "fetch_pages:"
  cfg = YAML.load_file( "#{@repo_path}/tables/config.yml") 
  pp cfg

  ## use www.rsssf.org - why? why not?
  dl_base = 'https://rsssf.org'

  cfg.each do |key,line|

     season = Season( key )
     next   if start && season < Season( start )
     next   if stop  && season > Season( stop )   ## note - will include stop season 
                                                  ## (stop NOT exclusive but inclusive)

     ## e.g.       tablesb/braz2013.html  --  Windows-1252
     ##        or  tablesb/braz2014.html  !! Windows-1252
     values = line.split( /--|!!/ ).map { |value| value.strip }
     path = values[0]

     encoding = values[1]  ## or nil

    ## season = k   # as string e.g. 2011-12  or 2011 etc.
  
    ## note: assumes extension is .html
    #    e.g. tablesd/duit2011.html => duit2011
    basename = File.basename( path, '.html' )

    src_url   = "#{dl_base}/#{path}"
    dest_path = "#{@repo_path}/tables/#{basename}.txt"

    page = if encoding 
               Page.from_url( src_url, encoding: encoding )
           else
               Page.from_url( src_url )
           end
    page.save( dest_path )
  end # each year
end # method fetch_pages



def make_schedules( cfg )

  ## note: return stats (for report eg. README)
  stats = []
  
  files = Dir[ "#{@repo_path}/tables/*.txt" ]
  files.each do |file|
    
## todo/check/fix:
##   use source: prop in rsssf page - why? why not???
##   move year/season/basename into page ???
#
#  assume every rsssf page has at least:
##    - basename  e.g. duit2014
##    - year      e.g. 2014 (numeric)
##    - season    (derived from config lookup???) - string e.g. 2014-15 or 2014 etc. 
    extname  = File.extname( file )
    basename = File.basename( file, extname )
    year     = year_from_name( basename )
    season   = year_to_season( year )

    if cfg.includes && cfg.includes.include?( year ) == false
      puts "   skipping #{basename}; not listed in includes"
      next
    end


    puts "  reading >#{basename}<"

    page = Page.from_file( file ) # note: always assume sources (already) converted to utf-8

    if cfg.opts_for_year.is_a?( Hash )
      opts = cfg.opts_for_year    ## just use as is 1:1 (constant/same for all years)
    else
      ## assume it's a proc/lambda (call to calculate)
      opts = cfg.opts_for_year.call( year ) 
    end
    pp opts

    schedule = page.find_schedule( opts )
    ## pp schedule

 
    if cfg.dir_for_year.nil?
      ## use default setting, that is, archive for dir (e.g. archive/1980s/1985-86 etc.)
      dir_for_year = archive_dir_for_year( year )
    else
      ## assume it's a proc/lambda
      dir_for_year = cfg.dir_for_year.call( year )
    end

    ## -- cfg.name               e.g. => 1-liga

    dest_path = "#{@repo_path}/#{dir_for_year}/#{cfg.name}.txt"
    puts "  save to >#{dest_path}<"
    FileUtils.mkdir_p( File.dirname( dest_path ))
    schedule.save( dest_path )

    rec = ScheduleStat.new
    rec.path     = dir_for_year
    rec.filename = "#{cfg.name}.txt"    ## change to basename - why?? why not?? 
    rec.year     = year
    rec.season   = season
    rec.rounds   = schedule.rounds

    stats << rec
  end

  stats  # return stats for reporting
end # method make_schedules




