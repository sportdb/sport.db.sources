
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


def convert

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


  
end

