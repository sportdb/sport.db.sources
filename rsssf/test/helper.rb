$LOAD_PATH.unshift( '../../sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../sport.db/parser-rsssf/lib' )

$LOAD_PATH.unshift( './lib' )
require 'rsssf'


## Webcache.root = './cache' 
Webcache.root = '/sports/cache'   ## use "global" (shared) cache



## minitest setup

require 'minitest/autorun'


## our own code
require 'rsssf'

