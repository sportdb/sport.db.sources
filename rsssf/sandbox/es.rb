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

class InlinePatchEs
  def patch( txt, name, year )
    puts "==> patch #{name} - #{year}"

    if name == 'span2016'
      # in Copa del Rey
# CD Mirandés               1-2 CA Osasuna                [awarded to Mirandés, Osasuna
# Córdoba CF                0-1 CD Lugo                    fielded suspended player]
     txt = txt.sub( /(fielded suspended player\])/, '⮑\1' )
# Real Madrid CF            o/w Cádiz CF                  [Real Madrid disqualified
# Real Sociedad             1-1 UD Las Palmas              for fielding suspended
# Valencia CF               2-0 Barakaldo CF               player in first leg]
   ## add NB:
     txt = txt.sub( '[Real Madrid disqualified',
                    '[NB: Real Madrid disqualified' ) 
     txt = txt.sub( /(for fielding suspended)/ , '⮑\1' )
     txt = txt.sub( /(player in first leg\])/, '⮑\1' )

      ### add support for  <team> disqualified - why? why not???
   end


   if name == 'span2011'
     #  in Primera División
# [Walter Pandiani 72; Sergio González79]     
  txt = txt.sub( 'González79',
                 'González 79' ) 
#  [Aritz Aduriz10, Vicente Rodríguez 90+; Igor Gabilondo 90+]
  txt = txt.sub( 'Aduriz10',
                 'Aduriz 10' ) 
#   ["Manu" Manuel del Moral Fernández70pen; Lionel Messi 22,
  txt = txt.sub( 'Fernández70pen',
                 'Fernández 70pen' ) 
#  [Diego Ifran 71, Xabi Prieto 82pen; Thiago Alcántara 29
#    mising closing ]
  txt = txt.sub( '[Diego Ifran 71, Xabi Prieto 82pen; Thiago Alcántara 29',
                 '[Diego Ifran 71, Xabi Prieto 82pen; Thiago Alcántara 29]'
               )
   end
    txt
  end
end

repo.patch_pages( InlinePatchEs.new )


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
