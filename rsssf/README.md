# rsssf - tools 'n' scripts for RSSSF (Rec.Sport.Soccer Statistics Foundation) archive data


* home  :: [github.com/sportdb/sport.db.sources](https://github.com/sportdb/sport.db.sources)
* bugs  :: [github.com/sportdb/sport.db.sources/issues](https://github.com/sportdb/sport.db.sources/issues)
* gem   :: [rubygems.org/gems/rsssf](https://rubygems.org/gems/rsssf)
* rdoc  :: [rubydoc.info/gems/rsssf](http://rubydoc.info/gems/rsssf)




## What's the Rec.Sport.Soccer Statistics Foundation (RSSSF)?

The RSSSF collects and offers football (soccer) league tables, match results and more
from all over the world online in plain text. Example:

```
Round 1
[May 25]
Vasco da Gama   1-0 Portuguesa
 [Carlos Tenório 47']
Vitória         2-2 Internacional
 [Maxi Biancucchi 2', Gabriel Paulista 11'; Diego Forlán 29', Fred 63']
Corinthians     1-1 Botafogo
 [Paulinho 73'; Rafael Marques 24']
[May 26]
Grêmio          2-0 Náutico         [played in Caxias do Sul-RS]
 [Zé Roberto 15', Elano 70']
Ponte Preta     0-2 São Paulo
 [Lúcio 9', Jádson 44'p]
Criciúma        3-1 Bahia
 [Matheus Ferraz 45'+1', Lins 46', João Vítor 82'; Diones 72']
Santos          0-0 Flamengo        [played in Brasília-DF]
Fluminense      2-1 Atlético/PR     [played in Macaé-RJ]
 [Rafael Sóbis 15'p, Samuel 53'; Manoel 28']
Cruzeiro        5-0 Goiás
 [Diego Souza 5', Bruno Rodrigo 30', Nílton 40',79', Borges 42']
Coritiba        2-1 Atlético/MG
 [Deivid 53', Arthur 90'+1'; Diego Tardelli 51']
```

[Find out more about the Rec.Sport.Soccer Statistics Foundation (RSSSF) »](http://www.rsssf.com)



## Usage

### Working with Pages

To fetch pages from the world wide web use:

``` ruby
page = RsssfPage.from_url( 'http://www.rsssf.com/tablese/eng2015.html')
```

Note: The `RsssfPageFetcher` will convert the rsssf archive page
from hypertext (HTML) to plain text e.g.

```
<hr>
<a href="#premier">Premier League</A><br>
<a href="#cups">Cup Tournaments</A><br>
<a href="#champ">Championship</A><br>
<a href="#first">Division 1</A><br>
<a href="#second">Division 2</A><br>
<a href="#conf">Conference</A>
<hr>
<h4><a name="premier">Premier League</A></h4>
<pre>
Final Table:

 1.Chelsea                 38  26  9  3  73-32  87  Champions
 2.Manchester City         38  24  7  7  83-38  79
 3.Arsenal                 38  22  9  7  71-36  75
...
```

will become

```
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
‹Premier League›
‹Cup Tournaments›
‹Championship›
‹Division 1›
‹Division 2›
‹Conference›
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#### Premier League


Final Table:

 1.Chelsea                 38  26  9  3  73-32  87  Champions
 2.Manchester City         38  24  7  7  83-38  79
 3.Arsenal                 38  22  9  7  71-36  75
...
```


### Working with Repos

To fetch pages from the world wide web for many seasons in batch setup and use a repo.

Step 1: List all archive pages

In the `tables/config.yml` list all archive pages to fetch. Example:

``` yaml
2010-11: tablese/eng2011.html
2011-12: tablese/eng2012.html
2012-13: tablese/eng2013.html
2013-14: tablese/eng2014.html
2014-15: tablese/eng2015.html
```

Step 2: Fetch all archive pages

Use:

``` ruby
repo = RsssfRepo.new( './eng-england', title: 'England (and Wales)' )
repo.fetch_pages
```

Bonus: To create a summary of all pages fetched (e.g. authors, last_updated, sections, etc.).
Use:

``` ruby
repo.make_pages_report
```

Example - `tables/README.md`:


football.db RSSSF Archive Data Summary for England (and Wales)

_Last Update: 2015-11-26 18:22:22 +0200_

| Season  | File   | Authors  | Last Updated | Lines (Chars) | Sections |
| :------ | :------ | :------- | :----------- | ------------: | :------- |
| 2014-15 | [eng2015.txt](https://github.com/rsssf/eng-england/blob/master/tables/eng2015.txt) | Ian King and Karel Stokkermans | 4 Jun 2015 | 1249 (34138) | Premier League, Cup Tournaments, Championship, Division 1, Division 2, Conference |
| 2013-14 | [eng2014.txt](https://github.com/rsssf/eng-england/blob/master/tables/eng2014.txt) | Ian King and Karel Stokkermans | 5 Feb 2015 | 1254 (34294) | Premier League, Cup Tournaments, Championship, Division 1, Division 2, Conference |
| 2012-13 | [eng2013.txt](https://github.com/rsssf/eng-england/blob/master/tables/eng2013.txt) | Karel Stokkermans | 5 Feb 2015 | 1269 (34531) | Premiership, Cup Tournaments, Championship, Division 1, Division 2, Conference |
| 2011-12 | [eng2012.txt](https://github.com/rsssf/eng-england/blob/master/tables/eng2012.txt) | Karel Stokkermans | 5 Feb 2015 | 691 (21925) | Premiership, Cup Tournaments, Championship, Division 1, Division 2, Conference |
| 2010-11 | [eng2011.txt](https://github.com/rsssf/eng-england/blob/master/tables/eng2011.txt) | Ian King, Karel Stokkermans and Jan Schoenmakers | 5 Feb 2015 | 959 (37393) | Premiership, Cup Tournaments, Championship, Division 1, Division 2, Conference |


That's it.


### Preparing Archive Pages for SQL Database Imports (e.g. football.db)

To import match schedules (fixtures and results) and more using the football.db machinery
prepare "simple" single league (or cup) pages with standings tables etc. stripped out.
For example, to break-out the Premier League and FA Cup from the `eng2015.txt`
archive page use:

``` ruby
page = RsssfPage.from_url( 'http://www.rsssf.com/tablese/eng2015.html')

schedule = page.find_schedule( header: 'Premier League')   ## returns RsssfSchedule obj
schedule.save( './1-premierleague.txt' )

schedule = page.find_schedule( header: 'FA Cup', cup: true )
schedule.save( './facup.txt' )
```



## RSSSF Datasets

See the rsssf github org for pre-processed ready-to-import datasets. Prepared repos include:

- [`england`](https://github.com/rsssf/england)    - rsssf archive data for England - Premier League, Championship, FA Cup etc.
- [`deutschland`](https://github.com/rsssf/deutschland) - rsssf archive data for Germany (Deutschland) - Deutsche Bundesliga, 2. Bundesliga, 3. Liga, DFB Pokal etc.
- [`espana`](https://github.com/rsssf/espana)      - rsssf archive data for España (Spain) - Primera División / La Liga, Copa de Rey, etc.
- [`austria`](https://github.com/rsssf/austria)     - rsssf archive data for Austria (Österreich) - Österr. Bundesliga, Erste Liga, ÖFB Pokal etc.
- [`brazil`](https://github.com/rsssf/brazil)      - rsssf archive data for Brazil (Brasil) - Campeonato Brasileiro Série A / Brasileirão etc.
- and more


## License

The `rsssf` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!

