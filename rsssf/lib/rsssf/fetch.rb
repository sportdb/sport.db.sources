
module Rsssf

class PageFetcher

  include Filters   # e.g. html2text, sanitize etc.


def read_cache( url )
  html = Webcache.read( url )

  puts "html:"
  pp html[0..400]

  html = convert( html, url: url )
  html
end   


### rename to download - why? why not?
def fetch( url, encoding: 'UTF-8' )

  ## note: assume plain 7-bit ascii for now
  ##  -- assume rsssf uses ISO_8859_15 (updated version of ISO_8859_1) 
  ###-- does NOT use utf-8 character encoding!!!
  response = Webget.page( url, encoding: encoding )  ## fetch (and cache) html page (via HTTP GET)

  ## note: exit on get / fetch error - do NOT continue for now - why? why not?
  exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
  
  puts "html:"
  html =  response.text( encoding: encoding )    
  pp html[0..400]

  html = convert( html, url: url )
  html
end



def convert( html, url: )
  ### todo/fix: first check if html is all ascii-7bit e.g.
  ## includes only chars from 64 to 127!!!

  ## normalize newlines
  ##   remove \r (form feed) used by Windows; just use \n (new line)
  html = html.gsub( "\r", '' )

  ## note:
  ##   assume (default) to ISO 3166-15 (an updated version of ISO 3166-1) for now
  ##
  ##  other possible alternatives - try:
  ##  - Windows CP 1562  or
  ##  - ISO 3166-2  (for eastern european languages )
  ##
  ## note: german umlaut use the same code (int)
  ##    in ISO 3166-1/15 and 2 and Windows CP1562  (other chars ARE different!!!)


  # html = html.force_encoding( Encoding::ISO_8859_15 )
  # html = html.encode( Encoding::UTF_8 )    # try conversion to utf-8

  ## check for html entities
  html = html.gsub( "&auml;", 'ä' )
  html = html.gsub( "&ouml;", 'ö' )
  html = html.gsub( "&uuml;", 'ü' )
  html = html.gsub( "&Auml;", 'Ä' )
  html = html.gsub( "&Ouml;", 'Ö' )
  html = html.gsub( "&Uuml;", 'Ü' )
  html = html.gsub( "&szlig;", 'ß' )

  html = html.gsub( "&oulm;", 'ö' )    ## support typo in entity (&ouml;)
  html = html.gsub( "&slig;", "ß" )    ## support typo in entity (&szlig;)
  
  html = html.gsub( "&Eacute;", 'É' )
  html = html.gsub( "&oslash;", 'ø' )
  

  ##############
  ## check for more entities
  ##   limit &---; to length 10 - why? why not?
  html = html.gsub( /&[^; ]{1,10};/) do |match|

    match =   if match == '&#307;'   ## use like Van D&#307;k  -> Van Dijk
                'ij'
              else
                puts "*** WARN - found unencoded html entity #{match}"
                match   ## pass through as is (1:1)
              end

    match   
  end
  ## todo/fix: add more entities


  txt   = html_to_txt( html )

  header = <<EOS
<!--
   source: #{url}
  -->

EOS

  header+txt  ## return txt w/ header
end  ## method fetch

end  ## class PageFetcher
end  ## module Rsssf


