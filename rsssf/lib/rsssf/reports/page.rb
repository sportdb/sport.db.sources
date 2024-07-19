

module Rsssf

class PageReport

attr_reader :title

def initialize( stats, title: 'Your Title Here'  )
  @stats = stats
    
  @title = title
end


def save( path )
  ### save report as README.md in repo
  write_text( path, build_summary )
end

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
    ## txt << "| #{stat.season} "
    txt << "| [#{stat.basename}.txt](#{stat.basename}.txt) "
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

