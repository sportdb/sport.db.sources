############
#  to run use:
#   $ ruby sandbox/de.rb

$LOAD_PATH.unshift( '../../sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../sport.db/parser-rsssf/lib' )


$LOAD_PATH.unshift( './lib' )
require 'rsssf'


Webcache.root = '/sports/cache'   ## use "global" (shared) cache



path = './tmp2/deutschland'
## path = '/sports/rsssf/deutschland' 


repo = RsssfRepo.new( path, title: 'Germany (Deutschland)' )

code    = 'de'
seasons = Season('1963/64')..Season('2023/24')
repo.prepare_pages( code, seasons )

repo.make_pages_summary




puts "bye"