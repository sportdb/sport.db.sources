############
#  to run use:
#   $ ruby sandbox/test_es.rb

$LOAD_PATH.unshift( '../../sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../sport.db/parser-rsssf/lib' )


$LOAD_PATH.unshift( './lib' )
require 'rsssf'


## Webcache.root = './cache' 

Webcache.root = '/sports/cache'   ## use "global" (shared) cache



## path = './tmp2/espana'
path = '/sports/rsssf/espana' 


repo = RsssfRepo.new( path, title: 'España (Spain)' )

code    = 'es'
seasons = Season('2010/11')..Season('2023/24')
repo.prepare_pages( code, seasons )

repo.make_pages_summary


repo.each_page( code, seasons ) do |season,page|
  next if season > Season('2015/16')

  puts "==> #{season}..."

  sched = page.find_schedule( header: 'Primera División' )
  sched.save( "#{repo.root}/#{season.to_path}/1-liga.txt",
              header: "= Spain Primera División #{season}\n\n" )
 
  sched = page.find_schedule( header: 'Copa del Rey', cup: true )
  sched.save( "#{repo.root}/#{season.to_path}/cup.txt",
              header: "= Spain Copa del Rey #{season}\n\n" )
end 

repo.make_schedules_summary


puts "bye"
