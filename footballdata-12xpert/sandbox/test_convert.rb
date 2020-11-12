$LOAD_PATH.unshift( "./lib" )
require 'footballdata/12xpert'

pp Footballdata12xpert::SOURCES_I
pp Footballdata12xpert::SOURCES_II


## step 1 - download
Footballdata12xpert.download
## step 2 - convert
Footballdata12xpert.convert

puts "bye"
