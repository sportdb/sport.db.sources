############
#  to run use:
#   $ ruby sandbox/es.rb


require_relative 'helper'



path = './tmp2/espana'
## path = '/sports/rsssf/espana' 

code    = 'es'
seasons = Season('2010/11')..Season('2023/24')
title   = 'España (Spain)'  


repo = RsssfRepo.new( path, title: title )

repo.prepare_pages( code, seasons )

repo.make_pages_summary

seasons = Season('2010/11')..Season('2015/16')
repo.each_page( code, seasons ) do |season,page|
  puts "==> #{season}..."

  sched = page.find_schedule( header: 'Primera División' )
  sched.save( "#{repo.root}/#{season.to_path}/1-liga.txt",
              header: "= Spain Primera División #{season}\n\n" )
 
  sched = page.find_schedule( header: 'Copa del Rey', cup: true )
  sched.save( "#{repo.root}/#{season.to_path}/cup.txt",
              header: "= Spain Copa del Rey #{season}\n\n" )
end 

repo.make_schedules_summary


puts "bye"
