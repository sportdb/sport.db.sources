class PatchEs
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
