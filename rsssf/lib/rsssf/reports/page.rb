

module Rsssf

class PageReport


def self.build( files, title:  )   
  stats = []
  files.each do |file|
    page = Page.read_txt( file )
    stats << page.build_stat
  end

  new( stats, title: title )
end


attr_reader :title

def initialize( stats, title: )
  @stats = stats
  @title = title
end

### save report as README.md in repo
def save( path ) write_text( path, build_summary ); end


def build_summary

  stats = @stats.sort do |l,r|
    r.year <=> l.year
  end

  header =<<EOS

# #{title}

football.db RSSSF Archive Data Summary for #{title}

EOS

## no longer add last update
##  _Last Update: #{Time.now}_


  txt = ''
  txt << header

  txt << "| File   | Authors  | Last Updated | Lines (Chars) | Sections |\n"
  txt << "| :----- | :------- | :----------- | ------------: | :------- |\n"

## note - removed season (no longer tracked here)

  stats.each do |stat|
    ## get basename from source url
    url_path  = URI.parse( stat.source ).path
    basename  = File.basename( url_path, File.extname( url_path ) )  ## e.g. duit92.txt or duit92.html => duit92
  
    txt << "| [#{basename}.txt](#{basename}.txt) "
    txt << "| #{stat.authors} "
    txt << "| #{stat.last_updated} "
    txt << "| #{stat.line_count} (#{stat.char_count}) "
    txt << "| #{stat.sections.join(', ')} "
    txt << "|\n"
  end

  txt << "\n\n" 
  txt
end  # method build_summary

end  ## class PageReport
end  ## module Rsssf

