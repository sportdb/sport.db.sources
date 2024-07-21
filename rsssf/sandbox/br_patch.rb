class PatchBr
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
