############
#  to run use:
#   $ ruby sandbox/eng.rb


require_relative 'helper'


path = './tmp2/england'
## path = '/sports/rsssf/england' 


code    = 'eng'
seasons = Season('1992/93')..Season('2023/24')
title   = 'England (and Wales)'

repo = RsssfRepo.new( path, title:  )
repo.prepare_pages( code, seasons )
    
repo.make_pages_summary


seasons = Season('2010/11')..Season('2023/24')
repo.each_page(code, seasons) do |season, page|
  puts "==> #{season}..."

  # note:  England 2010/11, 2011/12, 2012/13  uses
  #            Premiership  (not Premier League) for heading/section
  header = if season <= Season( '2012/13')
              'Premiership'
           else
              'Premier League'
           end

  sched = page.find_schedule( header: header )
  sched.save( "#{repo.root}/#{season.to_path}/1-premierleague.txt",
              header: "= England Premier League #{season}\n\n" )

  if season < Season( '2015/16' )
    sched = page.find_schedule( header: 'FA Cup', cup: true )
    sched.save( "#{repo.root}/#{season.to_path}/facup.txt",
                header: "= England FA Cup #{season}\n\n" )

    sched = page.find_schedule( header: 'League Cup', cup: true )
    sched.save( "#{repo.root}/#{season.to_path}/leaguecup.txt",
                header: "= England League Cup #{season}\n\n" )
  end
end


repo.make_schedules_summary


puts "bye"