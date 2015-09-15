# encoding: utf-8


module Rsssf

class PageReport

attr_reader :title

def initialize( stats, opts )
  @stats = stats
  @opts  = opts
    
  @title = opts[:title] || 'Your Title Here' 
end

def save( path )
  ### save report as README.md in repo
  File.open( path, 'w' ) do |f|
    f.write build_summary
  end
end

def build_summary

  stats = @stats.sort do |l,r|
    r.year <=> l.year
  end

  header =<<EOS

# #{title}

football.db RSSSF Archive Data Summary for #{title}

_Last Update: #{Time.now}_

EOS

  txt = ''
  txt << header

  txt << "| Season | File   | Authors  | Last Updated | Lines (Chars) | Sections |\n"
  txt << "| :----- | :----- | :------- | :----------- | ------------: | :------- |\n"

  stats.each do |stat|
    txt << "| #{stat.season} "
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

## add (shortcut) alias
RsssfPageReport = Rsssf::PageReport
