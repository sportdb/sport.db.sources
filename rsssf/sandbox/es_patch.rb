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

   # in Copa del Rey
note =<<TXT
  [Madrid: Iker Casillas; Alvaro Arbeloa, Sergio Ramos, Ricardo Carvalho
     (Ezequiel Garay 19), "Marcelo" Vieira da Silva, "Pepe" Kepler
     Laveran Lima, Xavi Alonso, Sami Khedira (Esteban Granero 104),
     Mesut Özil (Emmanuel Adebayor 70), "Cristiano Ronaldo" dos Santos,
     Angel Di María; coach: Jose Mourinho;
   Barcelona: Jose Manuel Pinto; "Dani Alves" Daniel Alves da Silva,
     Gerard Piqué, Javier Mascherano, "Adriano" Correia Claro
     (Scherrer Maxwell 119), Xavi Hernandez, Sergi Busquets
     (Seydou Keita 108), Andres Iniesta, Pedro Rodríguez, Lionel Messi,
     David Villa (Ibrahim Afellay 105); coach: Pep Guardiola;
   yellow cards:
     Madrid: Pepe 26, Xavi Alonso 60, Adebayor 74, Di María 86, 120;
     Barcelona: Pedro 34, Messi 64, Adriano 118;
   red card: Di María (M) 120 (2 yellow);
   ref: Alberto Undiano Mallenco;
   att: 50,000]
TXT
   txt = txt.sub( note, '' )

  # ["Jonathan" Apesteguía Olagüe " 44; Luis Blanco 68, Joel Alvarez 75]
  txt = txt.sub( %Q{Olagüe " 44}, 'Olagüe 44' ) 
  # [Juan Jose Serrano "Juanjo 60"]
  txt = txt.sub( %Q{"Juanjo 60"}, %Q{"Juanjo" 60} ) 
  # Benidorm                  0-0 Orihuela                  [aet. 3-5 pen]
  txt = txt.sub( '[aet.' , '[aet,' ) 

  
   end
    txt
  end
end
