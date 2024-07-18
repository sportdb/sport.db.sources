############
#  to run use:
#   $ ruby sandbox/test_eng.rb


$LOAD_PATH.unshift( './lib' )
require 'rsssf'


Webcache.root = './cache' 



repo = RsssfRepo.new( './tmp/england', title: 'England (and Wales)' )
# repo.fetch_pages
# repo.make_pages_summary


repo.each_page do |season, page|
  puts "==> #{season}..."

  # note:  England 2010/11, 2011/12, 2012/13  uses
  #            Premiership  (not Premier League) for heading/section
  header = if season <= Season( '2012/13')
              'Premiership'
           else
              'Premier League'
           end

  sched = page.find_schedule( header: header )
  ## pp sched
  sched.save( "./tmp/england/#{season.to_path}/1-premierleague.txt",
              header: "= England Premier League #{season}\n\n" )
end


__END__



puts "bye"