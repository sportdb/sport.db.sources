$LOAD_PATH.unshift( "./lib" )
require 'footballdata/12xpert'

pp Footballdata12xpert::SOURCES_I
pp Footballdata12xpert::SOURCES_II

ENG = Footballdata12xpert::SOURCES_I[:eng]
__END__

# Footballdata12xpert.download_season_by_season( ENG )


puts
# Footballdata12xpert.download_season_by_season( ENG, start: '2019/20' )


# Footballdata12xpert.download_all_seasons( 'AUT' )   ## format ii - all-seasons-in-one-datafile

# Footballdata12xpert.download
Footballdata12xpert.download( 'de', start: '2019/20' )
Footballdata12xpert.download( 'mx' )


Footballdata12xpert.convert( 'de', start: '2019/20' )
Footballdata12xpert.convert( 'mx', start: '2019/20' )

puts "bye"

