
module Rsssf



class Repo
  include Utils       ## e.g. year_from_file, etc.


def initialize( path, title: 'Your Title Here' )    ## pass in title etc.
  @repo_path = path
  @title     = title
end


def root() @repo_path; end    ## use/rename to path - why? why not?
alias_method :root_dir, :root


## for now use single country repos - why? why not?
##   add support for all-in-one repos
def prepare_pages( code, seasons )
  seasons.each do |season|
    url = Rsssf.table_url( code, season: season )

    ## check if not in cache
    unless Webcache.cached?( url )
        ## download - if not cached
        Rsssf.download_table( code, season: season )
    end

    page = Page.read_cache( url )

    url_path = URI.parse( url ).path
    puts "  url = >#{url}<"
    puts "  url_path = >#{url_path}<"

    basename = File.basename( url_path, File.extname( url_path ))

    path = "#{@repo_path}/tables/#{basename}.txt"
    page.save( path ) 
  end
end # method prepare_pages


def each_page( code, seasons, &blk )  ## use each table or such - why? why not?
  seasons.each do |season|
    url = Rsssf.table_url( code, season: season )
    url_path = URI.parse( url ).path
    puts "  url = >#{url}<"
    puts "  url_path = >#{url_path}<"
    basename = File.basename( url_path, File.extname( url_path ))

    path = "#{@repo_path}/tables/#{basename}.txt"
     page = Page.read_txt( path )
    season = Season( season )
    blk.call( season, page )
  end
end


def make_pages_summary
  files = Dir.glob( "#{@repo_path}/tables/*.txt" )
  report = PageReport.build( files, title: @title )    ## pass in title etc.  

  ### save report as README.md in tables/ folder in repo
  report.save( "#{@repo_path}/tables/README.md" )
end  # method make_pages_summary  


def make_schedules_summary
   ## find all match datafiles
   args = [@repo_path]
   files = SportDb::Parser::Opts.expand_args( args )
   pp files   
   
   report = ScheduleReport.build( files, title: @title )   ## pass in title etc.
   report.save( "#{@repo_path}/README.md" )
end  




def patch_pages( patcher )
  ## lets you run/use custom (repo/country-specific patches e.g. for adding/patching headings etc.)
  patch_dir( "#{@repo_path}/tables" ) do |txt, name, year|
    puts "patching #{year} (#{name}) (#{@repo_path})..."
    patcher.patch( txt, name, year )    ## note: must be last (that is, must return (patcher) t(e)xt)
  end
end ## method  patch_pages


def patch_dir( root, &blk )
  files = Dir.glob( "#{root}/**/*.txt" )
  ## pp files

  ## sort files by year (latest first)
  files = files.sort do |l,r|
    lyear = year_from_file( l )
    ryear = year_from_file( r )
    
    ryear <=> lyear
  end

  files.each do |file|
    txt = read_text( file )    ## note: assumes already converted to utf-8

    basename = File.basename( file, '.txt' )  ## e.g. duit92.txt => duit92
    year     = year_from_name( basename )

    new_txt = blk.call( txt, basename, year )
    ## calculate hash to see if anything changed ?? why? why not??

    write_text( file, new_txt )
  end # each file
end  ## patch_dir




end  ## class Repo
end  ## module Rsssf

