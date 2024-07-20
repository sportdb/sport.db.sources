
module Rsssf

## end_year to slug_year
##   check if generic rule/convention in use ???
## 2007-08: tablesd/duit08.html
## 2008-09: tablesd/duit09.html
## 2009-10: tablesd/duit2010.html
## 2010-11: tablesd/duit2011.html
## 2011-12: tablesd/duit2012.html


    ## map country codes to table pages
    ##   add options about (char) encoding ??? - why? why not?
  TABLE = {
    'eng' => ['tablese/eng{end_year}',   { encoding: 'Windows-1252' } ],
    'es'  => ['tabless/span{end_year}',  { encoding: 'Windows-1252' } ],
    'de'  => ['tablesd/duit{end_year}', { encoding: 'Windows-1252' } ],
    'at'  => ['tableso/oost{end_year}', { encoding: 'Windows-1252' }  ],
    'br'  => ['tablesb/braz{end_year}',  { encoding: 'Windows-1252' } ],
  }


  BASE_URL = "https://rsssf.org"


  def self.table_url( code, season: )
     url, _ = table_url_and_encoding( code, season: season )
     url 
  end

  def self.table_url_and_encoding( code, season: )
     table = TABLE[ code.downcase ]
     tmpl     = table[0]
     opts     = table[1] || {}
     encoding = opts[:encoding]  || 'UTF-8'

     season = Season( season )
     slug =  if season.end_year < 2010   ## cut off all digits (only keep last two)s
                 ##  convert end_year to string with leading zero
                 '%02d' % (season.end_year % 100)  ## e.g. 00 / 01 / 99 / 98 / 11 / etc.
              else
                '%4d' % season.end_year
              end

     tmpl = tmpl.sub( '{end_year}', slug )
     url = "#{BASE_URL}/#{tmpl}.html"

     [url, encoding]
  end


  def self.download_table( code, season: )
     url, encoding = table_url_and_encoding( code, season: season )

     download_page( url, encoding: encoding )
  end


  def self.download_page( url, encoding: )
 
    ## note: assume plain 7-bit ascii for now
    ##  -- assume rsssf uses ISO_8859_15 (updated version of ISO_8859_1) 
    ###-- does NOT use utf-8 character encoding!!!
    response = Webget.page( url, encoding: encoding )  ## fetch (and cache) html page (via HTTP GET)

    ## note: exit on get / fetch error - do NOT continue for now - why? why not?
    exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
  

    puts "html:"
    html =  response.text( encoding: encoding )    
    pp html[0..400]
    html
  end
end  # module Rsssf



__END__

1998-99: tablesd/duit99.html
1999-00: tablesd/duit00.html      ## use 1999-2000  - why?? why not??
2000-01: tablesd/duit01.html
2001-02: tablesd/duit02.html
2002-03: tablesd/duit03.html
2003-04: tablesd/duit04.html
2004-05: tablesd/duit05.html
2005-06: tablesd/duit06.html
2006-07: tablesd/duit07.html
2007-08: tablesd/duit08.html
2008-09: tablesd/duit09.html
2009-10: tablesd/duit2010.html
2010-11: tablesd/duit2011.html
2011-12: tablesd/duit2012.html
2012-13: tablesd/duit2013.html
2013-14: tablesd/duit2014.html
2014-15: tablesd/duit2015.html


2010-11: tableso/oost2011.html
2011-12: tableso/oost2012.html
2012-13: tableso/oost2013.html
2013-14: tableso/oost2014.html
2014-15: tableso/oost2015.html
2015-16: tableso/oost2016.html

2011: tablesb/braz2011.html  !! Windows-1252
2012: tablesb/braz2012.html  !! Windows-1252
2013: tablesb/braz2013.html  !! Windows-1252
2014: tablesb/braz2014.html  !! Windows-1252
2015: tablesb/braz2015.html  !! Windows-1252
2016: tablesb/braz2016.html  !! Windows-1252
2017: tablesb/braz2017.html  !! Windows-1252
2018: tablesb/braz2018.html  !! Windows-1252
2019: tablesb/braz2019.html  !! Windows-1252
2020: tablesb/braz2020.html  !! Windows-1252   ## 2020/21  - extended for corona
2021: tablesb/braz2021.html  !! Windows-1252
2022: tablesb/braz2022.html  !! Windows-1252
2023: tablesb/braz2023.html  !! Windows-1252
2024: tablesb/braz2024.html  !! Windows-1252

2010-11: tablese/eng2011.html  !! Windows-1252
2011-12: tablese/eng2012.html  !! Windows-1252
2012-13: tablese/eng2013.html  !! Windows-1252
2013-14: tablese/eng2014.html  !! Windows-1252
2014-15: tablese/eng2015.html  !! Windows-1252
2015-16: tablese/eng2016.html  !! Windows-1252
2016-17: tablese/eng2017.html  !! Windows-1252
2017-18: tablese/eng2018.html  !! Windows-1252
2018-19: tablese/eng2019.html  !! Windows-1252
2019-20: tablese/eng2020.html  !! Windows-1252
2020-21: tablese/eng2021.html  !! Windows-1252
2021-22: tablese/eng2022.html  !! Windows-1252
2022-23: tablese/eng2023.html  !! Windows-1252
2023-24: tablese/eng2024.html  !! Windows-1252


