$LOAD_PATH.unshift( "./lib" )
require 'footballdata/12xpert'

pp Footballdata12xpert::SOURCES_I
pp Footballdata12xpert::SOURCES_II


## set webget cache

Webcache.root = '../../../cache'  ### c:\sports\cache
pp Webcache.root

## step 1 - download
# Footballdata12xpert.download


# Footballdata12xpert.config.convert.out_dir = './tmp'
Footballdata12xpert.config.convert.out_dir = '../../../footballcsv/cache.footballdata'


# ## step 2 - convert
Footballdata12xpert.convert( start: '2021' )

puts "bye"
