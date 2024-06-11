$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
$LOAD_PATH.unshift( '../../../yorobot/sport.db.more/sportdb-linters/lib' )


require 'sportdb/catalogs'
require 'sportdb/linters'    # e.g. uses TeamSummary class


SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"



DATAFILES_DIR = '../../../footballcsv/cache.footballdata'


team_buf,   team_errors   = SportDb::TeamSummary.build( DATAFILES_DIR )

# File.open( "#{DATAFILES_DIR}/SUMMARY.md", 'w:utf-8' )  { |f| f.write( team_buf ) }

File.open( "./SUMMARY.md", 'w:utf-8' )  { |f| f.write( team_buf ) }


puts "#{team_errors.size} error(s) - teams:"
pp team_errors

puts 'bye'
