############
#  to run use:
#   $ ruby sandbox/test_br.rb


$LOAD_PATH.unshift( './lib' )
require 'rsssf'


Webcache.root = './cache' 


## is utf8 with BOM!!! (content char says otherwise)

# page = RsssfPage.from_url( 'https://rsssfbrasil.com/tablesae/br2023.htm',
#                             encoding: 'Windows-1252'
#                         )
# page.save( "./o/br2023.txt" )

=begin
page = RsssfPage.from_url( 'https://rsssf.org/tablesb/braz2011.html',
                              encoding: 'Windows-1252' )
page.save( "./o/br2010.txt" )
=end

=begin
page = RsssfPage.read_cache( 'https://rsssf.org/tablesb/braz2011.html' )
page.save( "./o/br2010v2.txt" )

page = RsssfPage.read_cache( 'https://rsssf.org/tablesb/braz2024.html' )
page.save( "./o/br2024v2.txt" )
=end

## path = './tmp/brazil'
path = '/sports/rsssf/brazil' 


repo = RsssfRepo.new( path, title: 'Brazil' )
# repo.fetch_pages    # ( stop: '2013' )

## todo/fix - season!!!  
##   displays 2021-22 etc. should be year only e.g. 2021!!!
##   remove season !!!!!
##   sort by number in basename ??
# repo.make_pages_summary


repo.each_page do |season, page|
   puts "==> #{season}..."
 
   sched = page.find_schedule( header: 'Série A' )
   ## pp sched
   sched.save( "#{repo.root}/#{season.to_path}/1-seriea.txt",
               header: "= Brazil Série A #{season}\n\n" )
end





__END__

cfg = ScheduleConfig.new
  cfg.name = '1-seriea'
  cfg.find_schedule_opts_for_year = ->(year) {  Hash[ header: 'S.rie A' ] }
  cfg.dir_for_year = ->(year) { year.to_s }   ## note: no mapping (season runs all year)
   ## Série A
   ## fix: utf-8 issue;  use S.rie A for now

  stats += make_schedules( BR, 'braz', BR_REPO, cfg )


## note - html page (show source) reads !!!
##   meta http-equiv="Content-Language" content="en-us">
## <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">



puts "bye"