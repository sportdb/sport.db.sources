# encoding: utf-8

module Rsssf
     
class ScheduleReport

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
  ## sort start by season (latest first) than by name (e.g. 1-bundesliga, cup, etc.)
  stats = @stats.sort do |l,r|
    v =  r.season   <=> l.season
    v =  l.filename <=> r.filename  if v == 0  ## same season
    v
  end

  header =<<EOS

# #{title}

football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) Archive Data for
#{title}

_Last Update: #{Time.now}_

EOS


  footer =<<EOS

## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum](http://groups.google.com/group/opensport).
Thanks!
EOS


  txt = ''
  txt << header
  
  txt << "| Season | League, Cup | Rounds |\n"
  txt << "| :----- | :---------- | -----: |\n"

  stats.each do |stat|
    txt << "| #{stat.season} "
    txt << "| [#{stat.filename}](#{stat.path}/#{stat.filename}) "
    txt << "| #{stat.rounds} "
    txt << "|\n"
  end

  txt << "\n\n" 

  txt << footer
  txt
end  # method build_summary

end  ## class ScheduleReport
end  ## module Rsssf

## add (shortcut) alias
RsssfScheduleReport = Rsssf::ScheduleReport

