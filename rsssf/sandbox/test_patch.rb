

txt =<<TXT
Köln            2-3     Wolfsburg
  0:1 Biliskov 3, 0:2 Petrow 26, 1:2 Scherz 35,
  2:2 Woronin 60, 2:3 Klimowicz 72.
Bayern München  3-3     Leverkusen
  0:1 Ramelow 10, 1:1 Makaay 25, 1:2 Franca 34,
  2:2 Santa Cruz 65, 3:2 Ballack 69, 3:3 Bastürk 81.
Bochum          2-2     Berlin
  0:1 Neuendorf 6, 1:1 Zdebel 45, 1:2 Neuendorf 66, 2:2 Hashemian 72.
Freiburg        2-1     Schalke
  1:0 Bajramovic 3, 1:1 Rodriguez 12, 2:1 Zkitischwili 39pen.
Hannover        2-0     Mönchengladbach
  1:0 Christiansen 18, 2:0 Idrissou 83.
Stuttgart       1-0     Dortmund
  1:0 Kuranyi 67.

TXT

puts txt

require 'season/formats'
require_relative 'de_patch'

patch = PatchDe.new


puts patch.on_patch( txt, 'duit04', 2004 )


txt =<<TXT

 [67 Kuster (Arminia) m/pen] 

 [57 Sieloff (M'gladbach)
     m/pen]
 
  [62
  Lütkebohmert (Schalke) m/pen]

  [10
   Zaczyk (Hamburger) m/pen]

  [44 H.Müller (Nürnberg) m/pen,
   24 Reisch (Nürnberg) m/pen]   

 [56 Rylewicz (Dortmund)
   m/pen]

 [30 Arnold [Stuttgart) m/pen]  



 (sent off: Karnhof (Schalke, 40), Rehhagel
              (Hertha, 40))
          
 (sent off: E.Kraus (TSV, 88))

 (sent off: Konietzka (Dortmund, 81), Wagner
                          (TSV, 81))

(sent off: Waldner (Stuttgart, 86), Wenger
                            (K'lautern, 82))

(sent off: Gerhardt (Fortuna, 28), Wabra (Nürnberg,
                          28))                            

(sent off: Kliemann (Hertha, ?))                         
TXT


puts txt
puts "---"
puts patch.on_parse( txt, '1-bundesliga', '9999' ).strip

puts "bye"