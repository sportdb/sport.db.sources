# footballdata-12xpert - download, convert & import 22+ top football leagues from 25 seasons back to 1993/94 from Joseph Buchdahl (12Xpert)'s Football Data website (football-data.co.uk) up and running since 2001 (and updated twice a week)


* home  :: [github.com/sportdb/sport.db.sources](https://github.com/sportdb/sport.db.sources)
* bugs  :: [github.com/sportdb/sport.db.sources/issues](https://github.com/sportdb/sport.db.sources/issues)
* gem   :: [rubygems.org/gems/footballdata-12xpert](https://rubygems.org/gems/footballdata-12xpert)
* rdoc  :: [rubydoc.info/gems/footballdata-12xpert](http://rubydoc.info/gems/footballdata-12xpert)
* forum :: [opensport](http://groups.google.com/group/opensport)



## What's Joseph Buchdahl's Football Data?

[Joseph Buchdahl (12Xpert)](https://twitter.com/12Xpert) has been publishing football data
at the [`football-data.co.uk`](https://www.football-data.co.uk/data.php) website
in the world's most popular tabular data interchange format in text, that is,
comma-separated value (.csv) records for (bulk) download (and offline usage) since 2001 (!).

The main top football leagues include:

- England (`E0`, `E1`, `E2`, `E3` & `EC`) - Premiership & Divs 1, 2, 3 & Conference
- Scotland  (`SC0`, `SC1`, `SC2` & `SC3`) - Premiership & Divs 1, 2 & 3
- Germany (`D1` & `D2`) - Bundesligas 1 & 2
- Italy (`I1` & `I2`) - Serie A & B
- Spain (`SP1` & `SP2`) - La Liga (Primera & Segunda)
- France (`F1` & `F2`) -  Le Championnat & Division 2
- Netherlands (`N1`) - Eredivisie
- Belgium (`B1`) - Pro League
- Portugal (`P1`) - Liga I
- Turkey (`T1`) - Ligi 1
- Greece (`G1`) -  Ethniki Katigoria

And the extra leagues include:

- Argentina (`ARG`) - Primera Division
- Austria (`AUT`) -  Bundesliga
- Brazil (`BRA`) -  Serie A
- China (`CHN`) - Super League
- Denmark (`DNK`) -  Superliga
- Finland (`FIN`) -  Veikkausliiga
- Ireland (`IRL`) - Premier Division
- Japan (`JPN`) -  J-League
- Mexico (`MEX`) -  Liga MX
- Norway (`NOR`) -  Eliteserien
- Poland (`POL`)-  Ekstraklasa
- Romania (`ROU`) -  Liga 1
- Russia (`RUS`) - Premier League
- Sweden (`SWE`) -   Allsvenskan
- Switzerland (`SWZ`) -  Super League
- USA (`USA`) -  Major League Soccer (MLS)


The top football leagues include 25 seasons back to 1993/94
and get at least updated twice weekly
(Sunday nights and Wednesday nights).


## Usage

[Download](#download) • [Convert](#convert) • [Import](#import)


### Download

Let's download all datasets (about 570+) for offline usage into the
default web cache directory (that is, `~/.cache/www.football-data.co.uk`):


``` ruby
require 'footballdata/12xpert'

Footballdata12xpert.download
```

Note: You can use `Footballdata12Xpert`,
`Footballdata_12xpert`, or `Footballdata_12Xpert`
as alternate alias names for `Footballdata12xpert`.



Stand back ten feet. Resulting in:

```
~/.cache/www.football-data.co.uk
│   ARG.csv
│   AUT.csv
│   BRA.csv
│   CHN.csv
│   DNK.csv
│   FIN.csv
│   IRL.csv
│   JPN.csv
│   MEX.csv
│   NOR.csv
│   POL.csv
│   ROU.csv
│   RUS.csv
│   SWE.csv
│   SWZ.csv
│   USA.csv
│
├───9394      # 1993/94 season by season main top leagues
│       D1.csv
│       D2.csv
│       E0.csv
│       E1.csv
│       E2.csv
│       E3.csv
│       F1.csv
│       I1.csv
│       N1.csv
│       SP1.csv
│
├───9495      # 1994/95 season by season main top leagues
│       D1.csv
│       D2.csv
│       E0.csv
│       E1.csv
│       E2.csv
│       E3.csv
│       F1.csv
│       G1.csv
│       I1.csv
│       N1.csv
│       P1.csv
│       SC0.csv
│       SC1.csv
│       SP1.csv
│       T1.csv
...
├───1920      # 2019/20 season by season main top leagues
│       B1.csv
│       D1.csv
│       D2.csv
│       E0.csv
│       E1.csv
│       E2.csv
│       E3.csv
│       EC.csv
│       F1.csv
│       F2.csv
│       G1.csv
│       I1.csv
│       I2.csv
│       N1.csv
│       P1.csv
│       SC0.csv
│       SC1.csv
│       SC2.csv
│       SC3.csv
│       SP1.csv
│       SP2.csv
│       T1.csv
│
└───2021      # 2020/21 season by season main top leagues
        B1.csv
        D1.csv
        D2.csv
        E0.csv
        E1.csv
        E2.csv
        E3.csv
        EC.csv
        F1.csv
        F2.csv
        N1.csv
        P1.csv
        SC0.csv
        SC1.csv
        SC2.csv
        SC3.csv
        SP1.csv
        SP2.csv
        T1.csv
```

The football datasets come in two flavors / formats.
The main leagues use season-by-season datafiles.
For example, `E0.csv`, `E1.csv`, `E2.csv`, `E3.csv` & `E4.csv` in the `2021`
season directory hold the matches for the English Premiership & Divs 1, 2, 3 & Conference;
`D1.csv` & `D2.csv` for the Bundesligas 1 & 2 and so on
for the 2020/21 season.

The extra leagues use an all-seasons-in-one datafile.
For example, `ARG.csv`
holds all seasons of the Argentinian Primera Division;
`AUT.csv` for the Austrian Bundesliga and so on.


Note: The datasets character encoding gets converted from
[Windows-1252 (8-bit)](https://en.wikipedia.org/wiki/Windows-1252) to UTF-8 (Unicode multi-byte).


Less is More?

You can download datasets for selected countries only. Pass in
the country keys. Let's download only England (`eng`)'s leagues:

``` ruby
Footballdata12xpert.download( 'eng' )
```

Or let's download only the top five leagues, that is,
England (`eng`), Spain (`es`), Germany (`de`), France (`fr`)
and Italy (`it`):

``` ruby
Footballdata12xpert.download( 'eng', 'es', 'de', 'fr', 'it' )
```

### Convert

Now what? Let's convert all football datasets from the web cache
to the one-line, one-record "standard" [Football.CSV format](https://github.com/footballcsv).
Example:


``` ruby
require 'footballdata/12xpert'

Footballdata12xpert.convert
```

Stand back ten feet. Resulting in:

```
./o
├───1993-94
│       de.1.csv
│       de.2.csv
│       eng.1.csv
│       eng.2.csv
│       eng.3.csv
│       eng.4.csv
│       es.1.csv
│       fr.1.csv
│       it.1.csv
│       nl.1.csv
│
├───1994-95
│       de.1.csv
│       de.2.csv
│       eng.1.csv
│       eng.2.csv
│       eng.3.csv
│       eng.4.csv
│       es.1.csv
│       fr.1.csv
│       gr.1.csv
│       it.1.csv
│       nl.1.csv
│       pt.1.csv
│       sco.1.csv
│       sco.2.csv
│       tr.1.csv
...
├───2020
│       ar.1.csv
│       br.1.csv
│       cn.1.csv
│       fi.1.csv
│       ie.1.csv
│       jp.1.csv
│       no.1.csv
│       se.1.csv
│       us.1.csv
│
└───2020-21
        at.1.csv
        be.1.csv
        ch.1.csv
        de.1.csv
        de.2.csv
        dk.1.csv
        eng.1.csv
        eng.2.csv
        eng.3.csv
        eng.4.csv
        eng.5.csv
        es.1.csv
        es.2.csv
```

Note: By default all datasets get written into the `./o`
directory.  Use `Footballdata12xpert.config.convert.out_dir`
to change the output directory.

The English Premier League (`eng.1`) results in `./o/2020-21/eng.1.csv`:

```
Date,Team 1,FT,HT,Team 2
Sat Sep 12 2020,Fulham,0-3,0-1,Arsenal
Sat Sep 12 2020,Crystal Palace,1-0,1-0,Southampton
Sat Sep 12 2020,Liverpool,4-3,3-2,Leeds
Sat Sep 12 2020,West Ham,0-2,0-0,Newcastle
Sun Sep 13 2020,West Brom,0-3,0-0,Leicester
Sun Sep 13 2020,Tottenham,0-1,0-0,Everton
Mon Sep 14 2020,Brighton,1-3,0-1,Chelsea
Mon Sep 14 2020,Sheffield United,0-2,0-2,Wolves
Sat Sep 19 2020,Everton,5-2,2-1,West Brom
Sat Sep 19 2020,Leeds,4-3,2-1,Fulham
Sat Sep 19 2020,Man United,1-3,0-1,Crystal Palace
...
```

Or the Brasileirão (`br.1`) in  `./o/2020/br.1.csv`:

```
Date,Team 1,FT,HT,Team 2
Sat Aug 8 2020,Fortaleza,0-2,?,Athletico-PR
Sat Aug 8 2020,Coritiba,0-1,?,Internacional
Sat Aug 8 2020,Sport Recife,3-2,?,Ceara
Sun Aug 9 2020,Flamengo RJ,0-1,?,Atletico-MG
Sun Aug 9 2020,Santos,1-1,?,Bragantino
Sun Aug 9 2020,Gremio,1-0,?,Fluminense
Wed Aug 12 2020,Athletico-PR,2-1,?,Goias
Wed Aug 12 2020,Atletico-MG,3-2,?,Corinthians
Wed Aug 12 2020,Bragantino,1-1,?,Botafogo RJ
Wed Aug 12 2020,Atletico GO,3-0,?,Flamengo RJ
Wed Aug 12 2020,Bahia,1-0,?,Coritiba
...
```

and so on.


Less is More?

You can convert datasets for selected countries only. Pass in
the country keys. Let's download only England (`eng`)'s leagues:

``` ruby
Footballdata12xpert.convert( 'eng' )
```

Or let's convert only the top five leagues, that is,
England (`eng`), Spain (`es`), Germany (`de`), France (`fr`)
and Italy (`it`):

``` ruby
Footballdata12xpert.convert( 'eng', 'es', 'de', 'fr', 'it' )
```

Or let's convert only the top five leagues starting from the 2019/20 season on:

``` ruby
Footballdata12xpert.convert( 'eng', 'es', 'de', 'fr', 'it', start: '2019/20' )
```


### Import

Now what? Let's import all football datasets from the web cache
into an SQL database.


``` ruby
SportDb.connect( adapter:  'sqlite3',
                 database: './football.db' )

SportDb.create_all   ## build database schema / tables


Footballdata12xpert.import
```

Note: Depending on your computing processing power the import might take
10+ minutes.


Done. Let's try some database (SQL) queries (using the sport.db ActiveRecord models):

``` ruby
## ActiveRecord model (convenience) shortcuts
Team   = SportDb::Model::Team
Match  = SportDb::Model::Match
League = SportDb::Model::League
Event  = SportDb::Model::Event


## Let's query for some stats  - How many teams? How many matches? etc.

puts Team.count   #=> 1143
# SELECT COUNT(*) FROM teams

puts Match.count   #=> 227_142
# SELECT COUNT(*) FROM matches

puts League.count  #=> 38
# SELECT COUNT(*) FROM leagues
```

Note: See the [SUMMARY.md](SUMMARY.md) page for a list of all 1000+ (canonical)
club names by country.

``` ruby
## Let's query for the Real Madrid football club from Spain

madrid = Team.find_by( name: 'Real Madrid' )
# SELECT * FROM teams WHERE name = 'Real Madrid' LIMIT 1

puts madrid.matches.count   #=> 1023
# SELECT COUNT(*) FROM matches WHERE (team1_id = 380 or team2_id = 380)
m = madrid.matches.first
# SELECT * FROM matches WHERE (team1_id = 380 or team2_id = 380) LIMIT 1

puts m.team1.name #=> CA Osasuna
puts m.team2.name #=> Real Madrid
puts m.score_str   #=> 1 - 4


## Or let's query for the Liverpool football club from England

liverpool = Team.find_by( name: 'Liverpool FC' )

puts liverpool.matches.count  #=> 1025

m = liverpool.matches.first
puts m.team1.title  #=> Liverpool FC
puts m.team2.title  #=> Sheffield Wednesday FC
puts m.score_str    #=> 2 - 0


## Let's try the English Premier League 2019/20

pl = Event.find_by( key: 'eng.1.2019/20' )

puts pl.matches.count  #=> 288

m = pl.matches.first
puts m.team1.title  #=> Liverpool FC
puts m.team2.title  #=> Norwich City FC
puts m.score_str    #=> 4 - 1

# and so on
```

That's it. Enjoy the beautiful game.



## Installation

Use

    gem install footballdata-12xpert

or add to your Gemfile

    gem 'footballdata-12xpert'



## License

The `footballdata-12xpert` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
