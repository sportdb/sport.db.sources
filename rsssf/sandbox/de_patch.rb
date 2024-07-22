

class PatchDe

## e.g. 2008/09
##   note: also support 1999/2000
SEASON = '\d{4}\/(\d{2}|\d{4})'  ## note: use single quotes - quotes do NOT get escaped (e.g. '\d' => "\\d")



DE_BUNDESLIGA1 = [
  ## e.g. 1.Bundesliga or 1. Bundesliga
  /^1\.( )?Bundesliga$/,  
]

DE_BUNDESLIGA2 = [
  ## e.g. Second Level 2008/09   $$
  ##      2.Bundesliga
  /^Second Level #{SEASON}\s+^2\.( )?Bundesliga$/,
  ## e.g. 2.Bundesliga or 2. Bundesliga
  /^2\.( )?Bundesliga$/,
  ## e.g. Germany 1998/99  2.Bundesliga
  /^Germany #{SEASON}\s+2\.( )?Bundesliga$/,
]


DE_LIGA3 = [
  ## e.g. Third Level 2008/09   $$
  ##      3.Bundesliga
  /^Third Level #{SEASON}\s+^3\.( )?Bundesliga$/,
]

DE_CUP = [
  ## e.g. Germany Cup (DFB Pokal) 1998/99
  /^Germany Cup \(DFB Pokal\) #{SEASON}$/,
  ## e.g. DFB Pokal 2008/09 or DFB-Pokal 1996/97
  /^DFB( |-)Pokal #{SEASON}$/,
  ## e.g. DFB-Pokal or DFB Pokal
  /^DFB( |-)Pokal$/,
  ## e.g. Cup 2006/07
  /^Cup #{SEASON}$/,  
]


def patch_heading( txt, rxs, title )
  rxs.each do |rx|
    txt = txt.sub( rx ) do |match|
      match = match.gsub( "\n", '$$')  ## change newlines to $$ for single-line outputs/dumps
      puts "  found heading >#{match}<"
      "\n\n#### #{title}\n\n"
    end
  end
  txt
end

### pass along page (obj) instead of txt - why? why not?

  def on_prepare( txt, name, year )

    if year < 2010   # note: duit2010 starts a new format w/ heading 4 sections etc.
      ##  puts "  format -- year < 2010"
      ## try to add section header (marker)
  
      txt = patch_heading( txt, DE_BUNDESLIGA1, '1. Bundesliga' )
      txt = patch_heading( txt, DE_BUNDESLIGA2, '2. Bundesliga' )
      txt = patch_heading( txt, DE_LIGA3,       '3. Liga'       )
      txt = patch_heading( txt, DE_CUP,         'DFB Pokal'     )
    end # year < 2010
     txt
  end


  def on_patch( txt, name, year )
    puts "  [debug] patch on_patch #{name}, #{year}"

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

    if name == 'duit07'
         #  'Diego'  => "Diego" 
         #  'Edu'
         #  'Juan'
         #  'Kahe'
         #  'Cacau'
        txt = txt.gsub( "'Diego'", %Q{"Diego"} ) 
        txt = txt.gsub( "'Edu'",   %Q{"Edu"} ) 
        txt = txt.gsub( "'Juan'",   %Q{"Juan"} ) 
        txt = txt.gsub( "'Kahe'",   %Q{"Kahe"} ) 
        txt = txt.gsub( "'Cacau'",   %Q{"Cacau"} ) 
    end

    if name == 'duit05'
    ## in cup
    ## change score at to  0:1 to 0-1, 1:1 to 1-1 etc.
    ##    [0:1 Azaough 60, 1:1 Dundee 82]
    ##    or
    ###   0:10 Jancker 71, 0:11 Kosowski 74, 0:12 Jancker 77, 0:13 Teber 82,
        txt = txt.gsub( /\b
                         (\d{1,2}):(\d{1,2})
                          \b/x,  '\1-\2' )
    end


    if name == 'duit75'
      ##  quick fix -  add missing closing )
      ## Bochum      3-2 1. FC Köln  (Balte 22 p, Eggert 44, Kaczor 74 - D.Müller 7,
      ##                       Löhr 35,
      txt = txt.sub( "        Löhr 35,", 
                     "        Löhr 35)" )
    end

    if name == 'duit74'
       ## in lines RW Essen    3-3 Stuttgart   (Erlhoff 66, 81 p, Ohlicher 87 - Weiß 20,
       ##                      Stickel 36, Ettmayer 65,
       txt = txt.sub( "Stickel 36, Ettmayer 65,", 
                      "Stickel 36, Ettmayer 65)" )

      ## Hamburger   4-2 Frankfurt   (Volkert 31, 66, Heese 78, Hönig 81 -
      ##                Rohrbach 40, 66,
      txt = txt.sub( "Rohrbach 40, 66,", 
                      "Rohrbach 40, 66)" )

      ## Frankfurt   2-2 Offenbach   (Hickersberger 86, Grabowski 88 p - Kliemann 16,
      ##                     Ritschel 53 p,
      txt = txt.sub( "       Ritschel 53 p,", 
                     "       Ritschel 53 p)" )

      ## Hannover    3-1 Hertha      (Damjanoff 43, Höfer 47, Siemensmeyer 77 p -
      ##               Brück 65,
      txt = txt.sub( "       Brück 65,", 
                     "       Brück 65)" )
    end

    if name == 'duit73'
      ##  quick fix -  add missing closing )
      ## in lines M'gladbach  3-2 Offenbach   (Wimmer 9, Surau 15, Heynckes 57 -
      ##                                 Schmitt 27, Schäfer 29,
       txt = txt.sub( "Schmitt 27, Schäfer 29,", 
                      "Schmitt 27, Schäfer 29)" )
       
      ## in line  - missing follow-up line ?
      ##    Offenbach   4-0 Bochum      (Schäfer 24, Hickersberger 53, Semlitsch 64 p,
      txt = txt.sub( "(Schäfer 24, Hickersberger 53, Semlitsch 64 p,", 
                     "(Schäfer 24, Hickersberger 53, Semlitsch 64 p)" )
 
       ## in line   - typo change - to ,
       ##   Hoeneß 72-  Wilbertz 58, Tenhagen 74, Kobluhn 75 p)
       txt = txt.sub( "Hoeneß 72-", "Hoeneß 72,")
                 
       ## in line
       ##   Bochum      2-0 Hannover    (Lameck 66, Balte68p)
       ##   Schalke     2-0 Stuttgart   (Braun 19, Kremers62p)
       txt = txt.sub( "Balte68p", "Balte 68p" )
       txt = txt.sub( "Kremers62p", "Kremers 62p" )

       txt = txt.sub( "(?)",  '' )
    end


    if name == 'duit72'
      ##  quick fix -  add missing closing )
      ##   in line  Duisburg     1-5 M'gladbach (L.Müller 15, 53, Wloka 27, Wunder 59, Heynckes 70,
       txt = txt.sub(  "(L.Müller 15, 53, Wloka 27, Wunder 59, Heynckes 70,",
                       "(L.Müller 15, 53, Wloka 27, Wunder 59, Heynckes 70)" )

      ##   in lines  Schalke      4-1 Bochum     (H.Kremers 14, Rüssmann 58, Fischer 61,
      ##                                          Fichtel 76 - Balte 56,
      txt = txt.sub(  "Fichtel 76 - Balte 56,",
                      "Fichtel 76 - Balte 56)" )

      ##  in lines Bayern      11-1 Dortmund   (G.Müller 11, 45, 83, 90, Hoeneß 20, 49, Roth
      ##                                  64, 88, W.Hoffmann 39, Beckenbauer 54,
      ##                                  Breitner 59 - Weinkauff 57
      txt = txt.sub(  "Breitner 59 - Weinkauff 57",
                      "Breitner 59 - Weinkauff 57)" )

      ##  add missing space                
      ## in line
      ##  B'schweig    1-1 Bayern     (Bäse 51- Haun 48 o)
      txt = txt.sub(  "Bäse 51-",
                      "Bäse 51 -" )

      ## in line
      ##   Bochum       4-2 Werder     (Walitza 19, 59. Wosab 67, Hartl 87 - Laumen 6,
      txt = txt.sub(  "Walitza 19, 59.",
                      "Walitza 19, 59," )                
    end

    if name == 'duit70'
      ### quick fix  - remove (?)
      ##  in line K'lautern  1-1 Schalke    (?)
      txt = txt.sub( "(?)",  '' )
    end

    if name == 'duit68'
      ## fix dot to comma for minute sep
      ## in line
      ##  1. FC Köln  2-5 M'gladbach  (Löhr 32, Simmet 89 - Meyer 65. 67, Wimmer 35, 87,
      txt = txt.sub( "Meyer 65. 67,",
                     "Meyer 65, 67," )
    end
    if name == 'duit67'
       ## add missing space
       ##  in line
       ##   M'gladbach11-0 Schalke    (Heynckes 21, 85, 90, Rupp 7, 41, 61, Laumen
       txt = txt.sub( "M'gladbach11-0 Schalke",
                      "M'gladbach 11-0 Schalke" )
    end

    txt
  end


def on_parse( txt, name, season )
  puts "  [debug] patch on_parse #{name}, #{season}"

## quick fix
##  remove crashing note for now
##   in DFB Pokal 2019/20
   if name == 'cup' && season == Season('2019/20')    # duit2020
  note =<<TXT
NB: 1.FC Saarbrücken are the first club ever to reach the cup semifinals while
    playing at the fourth league level (they were promoted to the third level
    at the end of May following the abandonment of their regional league); they
    host their cup matches in nearby Völklingen as the Ludwigspark stadium in
    Saarbrücken is undergoing renovation
TXT
    txt = txt.sub( note, '' )
   end


   if name == '1-bundesliga' && season == Season('2003/04' )
    ##        1:0 Klose 90.
    ##  or
    ##         1:0 van Lent 5pen, 1:1 Diabang 60, 1:2 Madsen 89, 2:2 van Lent 90.
    ###  or
    ##        0:1 Micoud 10, 0:2 Klasnic 40, 0:3 Stalteri 70, 1:3 Scherz 79,
    ##         1:4 Charisteas 90.
    ##  more
    ##  1:0-2:0 Rosicky 25, 51, 3:0 Amoroso 74, 4:0 Koller 87.
    ##    1:0-2:0-3:0 Max 18, 54, 66pen.
    ##   1:0 Franca 2, 2:0-3:0 Neuville 9, 51, 4:0 Bierofka 72.
    ##    1:0 Christiansen 16, 1:1-1:2 Max 43, 63,
    ##   2:2 Christiansen 66, 3:2 Simak 71, 3:3 Vorbeck 93.
    
           ## wrap in []
           ##   slurp up everything to next dot.
           ##   note - use gsub (global) - replace all
 
=begin           
           txt = txt.gsub( /  ( ^\s* )    ## 1) leading space   
                              (\d:\d \b   ## 2)
                               [^.]+?
                              ) 
                              ( \. )      ## 3) traling space (cut-off)
                          /ixm ,
                           '\1[\2]' ) 
=end 
          ### remove 
           txt = txt.gsub( /   ^\s*     
                              \d:\d \b  
                               [^.]+?
                               \. 
                          /ixm ,  '' ) 

        end

        if name == '1-bundesliga'
# quick hack: remove all  [] with  m/pen 
##    [67 Kuster (Arminia) m/pen]   for now
##
##  note - some are buggy e.g. 
##  [88 Cyliax (Dortmund) m/pen)  or such

             txt = txt.gsub( %r{ \[
                                     [^\]]+?   ## non-greedy
                                  m/pen  
                                     [^\]]*?   ## non-greedy
                                    \]
                             }ixm, '' )

### remove all (sent off: )
###  e.g.   (sent off: Karnhof (Schalke, 40), Rehhagel
##               (Hertha, 40))
##
###  plus typo e.g
##        (ent off: Sternkopf (Bayern, 87))
            txt = txt.gsub( %r{
                                 \(
                                    s?ent [ ] off:
                                       ( [^()]+?
                                         \(
                                             [^()]+?
                                         \)
                                       )+
                                 \)
                              }ixm, '' )        
  

        end

    txt
  end
end    # class PatchDe


=begin

Germany 1998/99  2.Bundesliga
Germany 1998/99 Third Level (Regionalliga)
- Regionalliga Nord
- Regionalliga Nordost
- Regionalliga S&uuml;d
- Regionalliga West/S&uuml;dwest




Third Level 2008/09
3.Bundesliga

Third Level 2003/04
- Regionalliga Nord
- Regionalliga Süd

Fourth Level (Oberligen) 2003/04
 - Bayern
 - Baden-Württemberg
 - Hessen
 - Südwest
 - Nordrhein
 - Westfalen
 - Niedersachsen/Bremen
 - Hamburg/Schleswig-Holstein
 - Nordost Nord
 - Nordost Süd
 

Fourth Level 2008/09
 - Regionalliga Nord
 - Regionalliga West
 - Regionalliga Süd
 
1.Bundesliga
2.Bundesliga

=end