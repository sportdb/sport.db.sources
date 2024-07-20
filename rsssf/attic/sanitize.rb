

### in repo.rb
def sanitize_pages
    ## for debugging/testing lets you (re)run sanitize  (alreay incl. in html2txt filter by default)
    sanitize_dir( "#{@repo_path}/tables" )
 end

 def sanitize_dir( root )
    files = Dir.glob( "#{root}/**/*.txt" )
  
    files.each do |file|
      txt = read_text( file )    ## note: assumes already converted to utf-8
  
      new_txt = sanitize( txt )
  
      write_text( file, new_txt )
    end # each file
  end  ## sanitize_dir
  




 ### in html2txt.rb (Filters)

def sanitize( txt )
  ### remove emails for (spam/privacy) protection
  ## e.g. (selamm@example.es)
  ##      (buuu@mscs.dal.ca)
  ##      (kaxx@rsssf.com)
  ##      (Manu_Maya@yakoo.co)

  ##   note add support for optional ‹› enclosure (used by html2txt converted a href :mailto links)
  ##   e.g. (‹selamm@example.es›)

  email_pattern = "\\(‹?[a-z][a-z0-9_]+@[a-z]+(\\.[a-z]+)+›?\\)"   ## note: just a string; needs to escape \\ twice!!!

  ## check for "free-standing e.g. on its own line" emails only for now
  txt = txt.gsub( /\n#{email_pattern}\n/i ) do |match|
    puts "removing (free-standing) email >#{match}<"
    "\n"   # return empty line
  end

  txt = txt.gsub( /#{email_pattern}/i ) do |match|
    puts "remove email >#{match}<"
    ''
  end

  txt  
end # method sanitize
