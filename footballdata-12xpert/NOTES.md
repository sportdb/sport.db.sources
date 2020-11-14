# Notes


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

