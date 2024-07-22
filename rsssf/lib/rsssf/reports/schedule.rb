

module Rsssf

  
ScheduleStat = Struct.new(
    :path,     ## path to .txt file
    :errors   ## array or nil
)



class ScheduleReport

  include Utils       ## e.g. year_from_file, etc.

##
##  quick hack?  pass along (optional) patch

def self.build( files, title:, 
                       patch: nil )
  linter = Parser::Linter.new

  stats = []
  files.each_with_index do |file,i|

    puts "==> [#{i+1}/#{files.size}] reading >#{file}<..."  

    txt = read_text( file )

    if patch && patch.respond_to?(:on_parse)
      season_dir = File.basename(File.dirname(file)) 
      season     = Season( season_dir )
      basename   = File.basename(file, File.extname(file)) 
      puts "  [debug] before  patch.on_parse #{basename}, #{season}"
      txt = patch.on_parse( txt, basename, season )
    end
  
    linter.parse( txt, parse: true,
                       path:  file  )   ## todo/fix - change path to file/filename - why? why not?
    
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

      season = Season( season_dir )
      ## note - use archive_dir_for_season for archive path
      

      txt << "| #{season_dir} "
      txt << "| [#{filename}](#{archive_dir_for_season(season)}/#{filename}) "
    
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

