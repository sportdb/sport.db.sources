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

class InlinePatchDe
  def patch( txt, name, year )
    puts "==> patch #{name} - #{year}"

    if name == 'duit2022'
      # in 1.Bundesliga
# Bochum          0-2 Mönchengladbach [abandoned at 0-2 in 70' due to crowd
# [Mar 19]                             trouble; result stood]
    # add note continuation marker
         txt = txt.sub( /(trouble; result stood\])/,
                            '⮑\1' )
    end

    if name == 'duit2016'
       # in DFB Pokal
#       Osnabrück              awd RB Leipzig             [awarded 0-2; abandoned at 1-0 in 71'
# Sankt Pauli            1-4 Borussia M'gladbach     after referee was hit by lighter]
    # add note continuation marker
        txt = txt.sub( /(after referee was hit by lighter\])/,
                            '⮑\1' )
    end

    txt
  end
end

repo.patch_pages( InlinePatchDe.new )




repo.make_pages_summary



## seasons = Season('1999/2000')..Season('2023/24')
seasons = Season('2020/21')..Season('2023/24')
repo.each_page( code, seasons ) do |season,page|
  puts "==> #{season}..."

  sched = page.find_schedule( header: '1\. Bundesliga' )
  sched.save( "#{repo.root}/#{archive_dir_for_season(season)}/1-bundesliga.txt",
              header: "= Deutsche Bundesliga #{season}\n\n" )

  sched = page.find_schedule( header: 'DFB Pokal', cup: true )
  sched.save( "#{repo.root}/#{archive_dir_for_season(season)}/cup.txt",
              header: "= DFB Pokal #{season}\n\n" )
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

 DE_REPO.make_schedules( cfg )


cfg.name = 'cup'
cfg.opts_for_year =  { header: 'DFB Pokal', cup: true }

## for debugging - use filer (to process only some files)
cfg.includes = (1997..2015).to_a

 DE_REPO.make_schedules( cfg )

