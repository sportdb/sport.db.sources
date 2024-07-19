

module Rsssf
     
class ScheduleReport

attr_reader :title

def initialize( datafiles, 
                  title: 'Your Title Here' )
  @datafiles = datafiles 
    
  @title = title
end

def save( path )
  ### save report as README.md in repo
  write_text( path,  build_summary )
end


def build_summary
  ## sort start 1) by season (latest first) than 
  ##            2) by name (e.g. 1-bundesliga, cup, etc.)
  datafiles = @datafiles.sort do |l,r|
    v =  File.basename(File.dirname(r)) <=> File.basename(File.dirname(l))
    v =  File.basename(l) <=> File.basename(r)    if v == 0  ## same season
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


  linter = Parser::Linter.new
  errors = []


  txt = String.new
  txt << header
  
  txt << "| Season | League, Cup | Errors |\n"
  txt << "| :----- | :---------- | -----: |\n"

  
  datafiles.each_with_index do |path,i|
      puts "==> [#{i+1}/#{datafiles.size}] reading >#{path}<..."
      linter.read( path, parse: true )

      season_dir = File.basename(File.dirname( path ))
      filename   = File.basename( path ) ## incl. extension !!

      txt << "| #{season_dir} "
      txt << "| [#{filename}](#{season_dir}/#{filename}) "
    
      txt <<   if linter.errors?
                 "|  **!! #{linter.errors.size}**  "
               else
                 "|  OK  "
               end
      txt << "|\n"
  
      errors += linter.errors  if linter.errors? 
  end

   if errors.size > 0
     txt << "\n\n"
     txt << "#{errors.size} errors in #{datafiles.size} datafile(s)\n\n"

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

