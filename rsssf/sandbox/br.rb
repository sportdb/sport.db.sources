############
#  to run use:
#   $ ruby sandbox/br.rb

require_relative  'helper' 

require_relative 'br_patch'


path = './tmp2/brazil'
## path = '/sports/rsssf/brazil' 

code    = 'br'
## start
seasons =  Season('1979')..Season('2024')
title   = 'Brazil (Brasil)'
patch   = PatchBr.new

repo = RsssfRepo.new( path, title: title, 
                            patch: patch )

repo.prepare_pages( code, seasons )


repo.make_pages_summary

## start find schedule at 2010
seasons = Season('2010')..Season('2024')
repo.each_page( code, seasons ) do |season,page|
  puts "==> #{season}..."

  sched = page.find_schedule( header: 'Série A' )
  sched.save( "#{repo.root}/#{season.to_path}/1-seriea.txt",
              header: "= Brazil Série A #{season}\n\n" )

end 

repo.make_schedules_summary



puts "bye"