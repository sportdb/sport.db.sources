


class RsssfPatcherDe < RsssfPatcher

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


def patch( txt, name, year )
  
  if year < 2010   # note: duit2010 starts a new format w/ heading 4 sections etc.
    ##  puts "  format -- year < 2010"
    ## try to add section header (marker)

    txt = patch_heading( txt, DE_BUNDESLIGA1, '1. Bundesliga' )
    txt = patch_heading( txt, DE_BUNDESLIGA2, '2. Bundesliga' )
    txt = patch_heading( txt, DE_LIGA3,       '3. Liga'       )
    txt = patch_heading( txt, DE_CUP,         'DFB Pokal'     )
  end # year < 2010

  txt
end # method patch

end # class RsssfPatcherDe



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
