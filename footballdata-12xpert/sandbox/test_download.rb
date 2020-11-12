$LOAD_PATH.unshift( "./lib" )
require 'sportdb/source/footballdata'

pp FOOTBALLDATA_SOURCES
# Footballdata.download_season_by_season( FOOTBALLDATA_SOURCES[:eng] )


puts
# Footballdata.download_season_by_season( FOOTBALLDATA_SOURCES[:eng], start: '2019/20' )


# Footballdata.download_all_seasons( 'AUT' )   ## format ii - all-seasons-in-one-datafile

# Footballdata.download
Footballdata.download( 'de', start: '2019/20' )
Footballdata.download( 'mx' )


Footballdata.convert( 'de', start: '2019/20' )
Footballdata.convert( 'mx', start: '2019/20' )

puts "bye"



