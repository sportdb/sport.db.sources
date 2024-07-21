

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


    if year < 2010   # note: duit2010 starts a new format w/ heading 4 sections etc.
      ##  puts "  format -- year < 2010"
      ## try to add section header (marker)
  
      txt = patch_heading( txt, DE_BUNDESLIGA1, '1. Bundesliga' )
      txt = patch_heading( txt, DE_BUNDESLIGA2, '2. Bundesliga' )
      txt = patch_heading( txt, DE_LIGA3,       '3. Liga'       )
      txt = patch_heading( txt, DE_CUP,         'DFB Pokal'     )
    end # year < 2010


## quick fix
##  remove crashing note for now
##   in DFB Pokal 2019/20
   if name == 'duit2020'
  note =<<TXT
NB: 1.FC Saarbrücken are the first club ever to reach the cup semifinals while
    playing at the fourth league level (they were promoted to the third level
    at the end of May following the abandonment of their regional league); they
    host their cup matches in nearby Völklingen as the Ludwigspark stadium in
    Saarbrücken is undergoing renovation
TXT
    txt = txt.sub( note, '' )
   end

    txt
  end
end


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