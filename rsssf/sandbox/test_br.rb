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

## repo = RsssfRepo.new( './tmp/brazil', title: 'Brazil' )
## repo.fetch_pages

##

# make schedules

years = [2011,2012,2013,2014,2015,2016]   #,2012]
years.each do |year|

    page = RsssfPage.from_file( "./tmp/brazil/tables/braz#{year}.txt" )

    sched = page.find_schedule( header: 'Série A' )
    pp sched
    sched.save( "./tmp/brazil/#{year}/1-seriea.txt")
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