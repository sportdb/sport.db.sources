
=begin
def self.from_url( url, encoding: 'UTF-8' )
  puts "   using encoding >#{encoding}<"

  txt = PageFetcher.new.fetch( url, encoding: encoding )
  from_string( txt )
end
=end

  # get path from url
  url  = URI.parse( source )
  ## pp url
  ## puts url.host
  path = url.path
  extname  = File.extname( path )
  basename = File.basename( path, extname )  ## e.g. duit92.txt or duit92.html => duit92
  year     = year_from_name( basename )
  season   = year_to_season( year )

  rec = PageStat.new
  rec.source       = source         # e.g. http://rsssf.org/tabled/duit89.html   -- use source_url - why?? why not??
  rec.basename     = basename       # e.g. duit89
  rec.year         = year           # e.g. 89 => 1989  -- note: always four digits
  rec.season       = season
  rec.authors      = authors
  rec.last_updated = last_updated
  rec.line_count   = line_count
  rec.char_count   = @txt.size      ## fix: use "true" char count not byte count
  rec.sections     = sections  

  PageStat = Struct.new(
    :source,     ## e.g. http://rsssf.org/tabled/duit89.html
    :basename,   ## e.g. duit89   -- note: filename w/o extension (and path)
    :year,       ## e.g. 1989     -- note: always four digits
    :season,     ## e.g. 1990-91  -- note: always a string (NOT a number)
    :authors,
    :last_updated,
    :line_count,  ## todo: rename to (just) lines - why? why not?
    :char_count,  ## todo: rename to (just) char(ectar)s  - why? why not?
    :sections)

    class Page

        include Utils   ## e.g. year_from_name, etc.
    end 
    
    
    