############
#  to run use:
#   $ ruby sandbox/at.rb


require_relative 'helper'



path = './tmp2/austria'
## path = '/sports/rsssf/austria' 

code    = 'at'
seasons = Season('1974/75')..Season('2023/24')   ## start 1974/75 
title   = 'Austria (Österreich)'


repo = RsssfRepo.new( path, title: title )
repo.prepare_pages( code, seasons )

repo.make_pages_summary

seasons = Season('2010/11')..Season('2015/16')
repo.each_page( code, seasons ) do |season,page|
  puts "==> #{season}..."

  sched = page.find_schedule( header: 'Bundesliga' )
  sched.save( "#{repo.root}/#{season.to_path}/1-bundesliga.txt",
              header: "= Austria Bundesliga #{season}\n\n" )
 
  sched = page.find_schedule( header: 'ÖFB Cup', cup: true )
  sched.save( "#{repo.root}/#{season.to_path}/cup.txt",
              header: "= Austria ÖFB Cup #{season}\n\n" )
end 

repo.make_schedules_summary


puts "bye"