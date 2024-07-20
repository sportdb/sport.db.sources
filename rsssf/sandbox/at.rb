############
#  to run use:
#   $ ruby sandbox/at.rb

$LOAD_PATH.unshift( '../../sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../sport.db/parser-rsssf/lib' )


$LOAD_PATH.unshift( './lib' )
require 'rsssf'


## Webcache.root = './cache' 

Webcache.root = '/sports/cache'   ## use "global" (shared) cache



path = './tmp2/austria'
## path = '/sports/rsssf/austria' 


repo = RsssfRepo.new( path, title: 'Austria (Österreich)' )

code    = 'at'
seasons = Season('2010/11')..Season('2023/24')
repo.prepare_pages( code, seasons )

repo.make_pages_summary


repo.each_page( code, seasons ) do |season,page|
  next if season > Season('2015/16')

  puts "==> #{season}..."

  sched = page.find_schedule( header: 'Bundesliga' )
  sched.save( "#{repo.root}/#{season.to_path}/1-bundesliga.txt",
              header: "= Austria Bundesliga #{season}\n\n" )
 
  sched = page.find_schedule( header: 'ÖFB Cup', cup: true )
  sched.save( "#{repo.root}/#{season.to_path}/cup.txt",
              header: "= Austria ÖFB Cup #{season}\n\n" )
end 

repo.make_schedules_summary


puts "bye"