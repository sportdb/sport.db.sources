############
#  to run use:
#   $ ruby sandbox/de.rb


require_relative 'helper'


## path = './tmp2/deutschland'
path = '/sports/rsssf/deutschland' 


code    = 'de'
seasons = Season('1963/64')..Season('2023/24')
title   = 'Germany (Deutschland)' 

repo = RsssfRepo.new( path, title: title )

repo.prepare_pages( code, seasons )

require_relative 'de_patch'
repo.patch_pages( PatchDe.new )


repo.make_pages_summary


seasons = Season('1963/64')..Season('2023/24')
# seasons = Season('1999/2000')..Season('2023/24')
## seasons = Season('2020/21')..Season('2023/24')
repo.each_page( code, seasons ) do |season,page|
  puts "==> #{season}..."

  kwargs = if season <= Season('1998/99')
             {}  # no header; assume single league file; return empty hash
           else
             { header: '1\. Bundesliga' }
           end
  sched = page.find_schedule( **kwargs )
  sched.save( "#{repo.root}/#{archive_dir_for_season(season)}/1-bundesliga.txt",
              header: "= Deutsche Bundesliga #{season}\n\n" )


  if season >= Season('1996/97')
    sched = page.find_schedule( header: 'DFB Pokal', cup: true )
    sched.save( "#{repo.root}/#{archive_dir_for_season(season)}/cup.txt",
                header: "= DFB Pokal #{season}\n\n" )
  end
end 


repo.make_schedules_summary


puts "bye"


__END__

cfg = RsssfScheduleConfig.new
cfg.name = '1-bundesliga'
cfg.opts_for_year = ->(year) {
  if year <= 1999
    {}  # no header; assume single league file; return empty hash
  else
    { header: '1\. Bundesliga' }
  end
}
## for debugging - use filer (to process only some files)
## cfg.includes = [1964, 1965, 1971, 1972, 2014, 2015]


cfg.name = 'cup'
cfg.opts_for_year =  { header: 'DFB Pokal', cup: true }

## for debugging - use filer (to process only some files)
cfg.includes = (1997..2015).to_a
