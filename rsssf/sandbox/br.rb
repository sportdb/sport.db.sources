############
#  to run use:
#   $ ruby sandbox/br.rb

require_relative  'helper' 


path = './tmp2/brazil'
## path = '/sports/rsssf/brazil' 

code    = 'br'
## start
seasons =  Season('1979')..Season('2024')
title   = 'Brazil (Brasil)'

repo = RsssfRepo.new( path, title: title )

repo.prepare_pages( code, seasons )


class InlinePatchBr
  def patch( txt, name, year )
    puts "==> patch #{name} - #{year}"

    if name == 'braz2019'
      # in Série A 
# Cruzeiro        0-2 Palmeiras       [abandoned at 0-2 in 86' due to crowd
# CSA             1-2 São Paulo        trouble]
   # add note continuation marker
   txt = txt.sub( /(trouble\])/,
                   '⮑\1' )
    end

    if name == 'braz2015'
      # in Série A
      #   [Paulinho 49'; Anderson Lopes 0'45", Roberto 78']
      txt = txt.sub( %Q{Anderson Lopes 0'45"}, "Anderson Lopes 45'" ) 
      #    [Diego Olivera 0'55", Tiago Alves 38', Borges 76']
      txt = txt.sub( %Q{Diego Olivera 0'55"}, "Diego Olivera 55'" )
      #    [Gabriel Jesus 0'48", 67', Dudu 23'; Marcelinho Paraíba 26',27']
      txt = txt.sub( %Q{Gabriel Jesus 0'48"}, "Gabriel Jesus 48'" )
      #    [Fred 79'; Juan 0'25", João Paulo 45'+2', Henrique Almeida 90'+3']
      txt = txt.sub( %Q{Juan 0'25"}, "Juan 25'" )
    end

    if name == 'braz2013'
      # in Série A
      #   [Juan 14', Otavinho 87'; João Paulo 37", Éderson 74']
      txt = txt.sub( %Q{João Paulo 37"}, "João Paulo 37'" ) 
      #   [Maikon Leite 50'; Thiago Ribeiro 40", Cícero 21',89', Éverton Costa 24', Cicinho 26']
      txt = txt.sub( %Q{Thiago Ribeiro 40"}, "Thiago Ribeiro 40'" ) 
    end

    if name == 'braz2012'
      # in Série A
      #   [Ademilson 49", Willian José 90'+3']
      txt = txt.sub( %Q{Ademilson 49"}, "Ademilson 49'" ) 
    end  
    txt
  end
end

repo.patch_pages( InlinePatchBr.new )


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