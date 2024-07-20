

module Rsssf

  
ScheduleStat = Struct.new(
    :path,     ## path to .txt file
    :errors   ## array or nil
)



class ScheduleReport

def self.build( files, title: )
  linter = Parser::Linter.new

  stats = []
  files.each_with_index do |file,i|

    puts "==> [#{i+1}/#{files.size}] reading >#{file}<..."  
    linter.read( file, parse: true )
    
    stat = ScheduleStat.new
    stat.path   = file
    stat.errors = linter.errors
     
    stats << stat
  end

  new( stats, title: title )
end


attr_reader :title

def initialize( stats,  title: )
  @stats = stats 
  @title = title
end

### save report as README.md in repo
def save( path ) write_text( path, build_summary ); end


def build_summary
  ## sort start 1) by season (latest first) than 
  ##            2) by name (e.g. 1-bundesliga, cup, etc.)
  stats = @stats.sort do |l,r|
    v =  File.basename(File.dirname(r.path)) <=> File.basename(File.dirname(l.path))
    v =  File.basename(l.path) <=> File.basename(r.path)    if v == 0  ## same season
    v
  end

  header =<<EOS

# #{title}

football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) Archive Data for
#{title}

EOS

## no longer add last update
## _Last Update: #{Time.now}_
##


=begin
  footer =<<EOS

## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum](http://groups.google.com/group/opensport).
Thanks!
EOS
=end


  errors = []


  txt = String.new
  txt << header
  
  txt << "| Season | League, Cup | Errors |\n"
  txt << "| :----- | :---------- | -----: |\n"

  
  stats.each_with_index do |stat,i|
 
      path = stat.path
      season_dir = File.basename(File.dirname( path ))
      filename   = File.basename( path ) ## incl. extension !!

      txt << "| #{season_dir} "
      txt << "| [#{filename}](#{season_dir}/#{filename}) "
    
      txt <<   if stat.errors.size > 0
                 "|  **!! #{stat.errors.size}**  "
               else
                 "|  OK  "
               end
      txt << "|\n"
  
      errors += stat.errors  if stat.errors.size > 0 
  end

   if errors.size > 0
     txt << "\n\n"
     txt << "#{errors.size} errors in #{stats.size} datafile(s)\n\n"

     txt << "```\n"
     errors.each do |path, msg, line|
        season_dir = File.basename(File.dirname( path ))
        filename   = File.basename( path ) ## incl. extension !!
  
        txt <<"#{season_dir}/#{filename} -- #{msg}\n"
        txt << "     in line >#{line}<\n"    unless line.empty?
     end
     txt << "```\n"
   end

=begin
  stats.each do |stat|
    txt << "| #{stat.season} "
    txt << "| [#{stat.filename}](#{stat.path}/#{stat.filename}) "
    txt << "| #{stat.rounds} "
    txt << "|\n"
  end
=end

 
  ## txt << footer
  txt
end  # method build_summary

end  ## class ScheduleReport
end  ## module Rsssf

