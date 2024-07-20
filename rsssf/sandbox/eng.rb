############
#  to run use:
#   $ ruby sandbox/eng.rb



$LOAD_PATH.unshift( '../../sport.db/parser/lib' )
$LOAD_PATH.unshift( '../../sport.db/parser-rsssf/lib' )


$LOAD_PATH.unshift( './lib' )
require 'rsssf'



Webcache.root = '/sports/cache' 


path = './tmp2/england'
## path = '/sports/rsssf/england' 


repo = RsssfRepo.new( path, title: 'England (and Wales)' )
code    = 'eng'
seasons = Season('2010/11')..Season('2023/24')
repo.prepare_pages( code, seasons )
    
repo.make_pages_summary

##  check for &uml; fix???
## 2020-21/1-premierleague.txt -- parse error (INSIDE_RE) - skipping >G&< @22,25
##       in line >[Bernardo Silva 79, G&uml;ndogan 90pen]<


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