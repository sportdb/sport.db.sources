# Notes


## Data Changes / Fixes in 2024 

what changed in 2024 (last update was 2020)

```
1994/95 - eng.4
  match result fix -
- Thu May 4 1995,Bury,0-2,?,Walsall
+ Thu May 4 1995,Bury,0-0,?,Walsall

club renames
in at 
  Rapid Vienna => SK Rapid
in ro
  FC Steaua Bucuresti => FCSB
in ru
  FK Krylya Sovetov Samara =>  Krylya Sovetov
in jp
  G-Osaka  => Gamba Osaka
  C-Osaka  => Cerezo Osaka
  Hiroshima  => Sanfrecce Hiroshima
  Urawa  => Urawa Reds
  Kobe  => Vissel Kobe
  Nagoya =>  Nagoya Grampus
  Shimizu  =>  Shimizu S-Pulse
  Sapporo  =>  Hokkaido Consadole Sapporo
  Yokohama M. => Yokohama F. Marinos
  Shonan => Shonan Bellmare
  Oita => Oita Trinita
  !! Kashima  =>  Kashima Antler    # note - now tow different clubs!!!
  !! Kashiwa  =>  Kashiwa Reysol  
in us
  Montreal Impact  => CF Montreal
in cn
  Henan Jianye => Henan Songshan Longmen
  Tianjin Teda  =>  Tianjin Jinmen Tiger

```



## Alternative Packages / Libraries

**JavaScript**

- <https://github.com/irsooti/football-data-scraper> - TypeScript (JavaScript) by Daniele Irsuti
  - <https://www.npmjs.com/package/@irsooti/football-data-scraper>

**Ruby**

- <https://rubygems.org/gems/kickme> - download data from football data uk
  - <https://github.com/sunrick/kickme> by Rickard Sundén

**Python**

- <https://github.com/olalidmark/football-data> by Ola Lidmark Eriksson
  - <https://github.com/olalidmark/football-data/blob/master/fbdata/fbdata.py>

<!-- break -->

- <https://pypi.org/project/footballdata>
  - <https://github.com/skagr/footballdata> by Skag Rijsdijk
    - <https://github.com/skagr/footballdata/blob/master/footballdata/MatchHistory.py>

**C#**

- <https://github.com/Garand-Gary/Football-Data.co.uk>



##  Todos

fix with mods(?) ambigious club names e.g.

- Extremadura   in Spain

```
** !!! ERROR - too many matches (2) for club >Extremadura<:
[#<Sports::Club:0x5148720
  @alt_names=["Extremadura"],
  @alt_names_auto=[],
  @city="Almendralejo",
  @geos=["Extremadura"],
  @name="CF Extremadura (-2010)",
  @year_end=2010>,
 #<Sports::Club:0x512a900
  @alt_names=
   ["Extremadura", "Extremadura Uni\u00F3n Deportiva", "UD Extremadura"],
  @alt_names_auto=["Extremadura Union Deportiva"],
  @city="Almendralejo",
  @geos=["Extremadura"],
  @name="Extremadura UD">]


** !!! ERROR - too many matches (2) for club >Extremadura<:

[#<Sports::Club:0x00000155550edbb0
  @alt_names=[],
  @city="Almendralejo",
  @code=nil,
  @country=
   #<Sports::Country:0x000001555504eec0
    @alt_names=["España [es]"],
    @code="ESP",
    @key="es",
    @name="Spain",
    @tags=["fifa", "uefa"]>,
  @district=nil,
  @key="cfextremadura(-2010)",
  @name="CF Extremadura (-2010)">,
 #<Sports::Club:0x00000155550edb10
  @alt_names=[],
  @city="Almendralejo",
  @code=nil,
  @country=
   #<Sports::Country:0x000001555504eec0
    @alt_names=["España [es]"],
    @code="ESP",
    @key="es",
    @name="Spain",
    @tags=["fifa", "uefa"]>,
  @district=nil,
  @key="extremaduraud",
  @name="Extremadura UD">]
```



## Mapping of CSV Fields

See <https://www.football-data.co.uk/notes.txt> for the official list.

```
Key to results data:

Div = League Division
Date = Match Date (dd/mm/yy)
HomeTeam = Home Team
AwayTeam = Away Team
FTHG and HG = Full Time Home Team Goals
FTAG and AG = Full Time Away Team Goals
FTR and Res = Full Time Result (H=Home Win, D=Draw, A=Away Win)
HTHG = Half Time Home Team Goals
HTAG = Half Time Away Team Goals
HTR = Half Time Result (H=Home Win, D=Draw, A=Away Win)
```

Note: Not all datafiles follow the key. The real usage is:

```
{"Date"=>570,
 "Time"=>35,
 "HomeTeam"=>549, "HT"=>5, "Home"=>16,
 "AwayTeam"=>549, "AT"=>5, "Away"=>16,
 "FTHG"=>554,  "HG"=>16,
 "FTAG"=>554,  "AG"=>16,
 "HTHG"=>488,
 "HTAG"=>488 }
```

e.g.
- `HomeTeam` is `Home` in 16 datafiles and `HT` in 5
- `AwayTeam` is `Away` in 16 datafiles and `AT` in 5
- ...

