############
#  to run use:
#   $ ruby sandbox/download.rb

require_relative 'helper'




# try germany
seasons = Season('1963/64')..Season('2023/24')
pp seasons.to_a
pp seasons.size

seasons.each_with_index do |season, i|
  Rsssf.download_table( 'de', season: season )
  url = Rsssf.table_url( 'de', season: season )
  pp url
end


__END__

seasons = Season('2010/11')..Season('2023/24')
pp seasons.to_a
pp seasons.size

seasons.each_with_index do |season, i|
  Rsssf.download_table( 'at', season: season )
  url = Rsssf.table_url( 'at', season: season )
  pp url
end


__END__
html =  Rsssf.download_table( 'eng', season: '2012/13' )

url = Rsssf.table_url( 'eng', season: '2012/13' )
pp url

puts "bye"