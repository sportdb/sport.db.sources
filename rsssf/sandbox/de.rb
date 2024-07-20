############
#  to run use:
#   $ ruby sandbox/de.rb


require_relative 'helper'


path = './tmp2/deutschland'
## path = '/sports/rsssf/deutschland' 


code    = 'de'
seasons = Season('1963/64')..Season('2023/24')
title   = 'Germany (Deutschland)' 

repo = RsssfRepo.new( path, title: title )

repo.prepare_pages( code, seasons )


## add patch pages here - why? why not?
# task :deii do
#    patcher_de = RsssfPatcherDe.new
#    DE_REPO.patch_pages( patcher_de )
#  end
  

repo.make_pages_summary


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

 DE_REPO.make_schedules( cfg )


cfg.name = 'cup'
cfg.opts_for_year =  { header: 'DFB Pokal', cup: true }

## for debugging - use filer (to process only some files)
cfg.includes = (1997..2015).to_a

 DE_REPO.make_schedules( cfg )

