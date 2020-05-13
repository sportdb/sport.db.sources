# encoding: utf-8

module Rsssf

class PageFetcher

  include Filters   # e.g. html2text, sanitize etc.


def initialize
  @worker = Fetcher::Worker.new
end
  
def fetch( src_url )

  ## note: assume plain 7-bit ascii for now
  ##  -- assume rsssf uses ISO_8859_15 (updated version of ISO_8859_1) -- does NOT use utf-8 character encoding!!!
  html = @worker.read( src_url )  

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

  html = html.force_encoding( Encoding::ISO_8859_15 )
  html = html.encode( Encoding::UTF_8 )    # try conversion to utf-8

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
  
  ## check for more entities
  html = html.gsub( /&[^;]+;/) do |match|
    puts "*** found unencoded html entity #{match}"
    match   ## pass through as is (1:1)
  end
  ## todo/fix: add more entities


  txt   = html_to_txt( html )

  header = <<EOS
<!--
   source: #{src_url}
  -->

EOS

  header+txt  ## return txt w/ header
end  ## method fetch

end  ## class PageFetcher
end  ## module Rsssf

## add (shortcut) alias
RsssfPageFetcher = Rsssf::PageFetcher

