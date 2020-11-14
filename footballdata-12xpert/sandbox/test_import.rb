$LOAD_PATH.unshift( "../../sport.db/sportdb-importers/lib" )
$LOAD_PATH.unshift( "./lib" )
require 'footballdata/12xpert'


SportDb.connect( adapter:  'sqlite3',
                 database: ':memory:' )

## build database schema / tables
SportDb.create_all


## step 3 - import
Footballdata12xpert.import

puts "bye"
