# encoding: utf-8


module Rsssf

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


###
## note:
#    a rsssf page may contain:
#     many leagues, cups
#     - tables, schedules (rounds), notes, etc.
#
#   a rsssf page MUST be in plain text (.txt) and utf-8 character encoding assumed
#

class Page

  include Utils   ## e.g. year_from_name, etc.

def self.from_url( src )
  txt = PageFetcher.new.fetch( src )
  self.from_string( txt )
end


def self.from_file( path )
  txt = File.read_utf8( path )  # note: always assume sources (already) converted to utf-8 
  self.from_string( txt )
end

def self.from_string( txt )
  self.new( txt )
end
  
def initialize( txt )
  @txt = txt
end


LEAGUE_ROUND_REGEX = /\b
                      Round
                      \b/ix

CUP_ROUND_REGEX  = /\b(
                      Round         |
                      1\/8\sFinals  |
                      1\/16\sFinals |
                      Quarterfinals |
                      Semifinals    |
                      Final
                    )\b/ix

def find_schedule( opts={} )     ## change to build_schedule - why? why not???

  ## find match schedule/fixtures in multi-league doc
  new_txt = ''

  ## note: keep track of statistics
  ##   e.g. number of rounds found
  
  round_count = 0

  header = opts[:header]
  if header
    league_header_found        = false

     ## header:
     ##  - assumes heading 4 e.g. #### Premier League or
     ##  - bold e.g. **FA Cup** for now
     ##  note: markers must start line (^)

     ## note:
     ## header gsub spaces to \s otherwise no match in regex (using free-form x-flag)!!!
     header_esc   = header.gsub( ' ', '\s' )

     ## note: somehow #{2,4} will not work with free-form /xi defined (picked up as comment?)
     ##  use [#] hack ??
     header_regex = /^
                      ([#]{2,4}\s+(#{header_esc}))
                        |
                      (\*{2}(#{header_esc})\*{2})
                    /ix

    ## todo:
    ##   use new stage_regex e.g. **xxx** - why? why not?
    ##  allow more than one stage in one schedule (e.g. regular stage,playoff stage etc)

  else
    league_header_found = true   # default (no header; assume single league file)
    header_regex = /^---dummy---$/  ## non-matching dummy regex
  end

  ## puts "header_regex:"
  ## pp header_regex


  if opts[:cup]
    round_regex = CUP_ROUND_REGEX   ## note: only allow final, quaterfinals, etc. if knockout cup
  else
    round_regex = LEAGUE_ROUND_REGEX
  end


  ## stages
  first_round_header_found   = false
  round_header_found         = false
  round_body_found           = false   ## allow round header followed by blank lines

  blank_found = false



  @txt.each_line do |line|

    if league_header_found == false
      ## first find start of league header/section
      if line =~ header_regex
        puts "!!! bingo - found header >#{line}<"
        league_header_found = true
        title = line.gsub( /[#*]/, '' ).strip   ##  quick hack: extract title from header
        new_txt << "## #{title}\n\n"    # note: use header/stage title (regex group capture)
      else
        puts "  searching for header >#{header}<; skipping line >#{line}<"
        next
      end
    elsif first_round_header_found == false
      ## next look for first round (starting w/ Round)
      if line =~ round_regex
        puts "!!! bingo - found first round >#{line}<"
        round_count += 1
        first_round_header_found = true
        round_header_found       = true
        round_body_found         = false
        new_txt << line
      elsif line =~ /^=-=-=-=/
        puts "*** no rounds found; hit section marker (horizontal rule)"
        break
      elsif line =~ /^\*{2}[^*]+\*{2}/   ## e.g. **FA Cup**
        puts "*** no rounds found; hit section/stage header: #{line}"
        break
      else
        puts "  searching for first round; skipping line >#{line}<"
        next ## continue; searching
      end
    elsif round_header_found == true
      ## collect rounds;
      ##   assume text block until next blank line
      ##   new block must allways start w/ round
      if line =~ /^\s*$/   ## blank line?
        if round_body_found
          round_header_found = false
          blank_found        = true    ## keep track of blank (lines) - allow inside round block (can continue w/ date header/marker)
          new_txt << line
        else
          ## note: skip blanks following header
          next
        end
      else
        round_body_found = true
        new_txt << line   ## keep going until next blank line
      end
    else
      ## skip (more) blank lines
      if line =~ /^\s*$/
        next  ## continue; skip extra blank line
      elsif line =~ round_regex
        puts "!!! bingo - found new round >#{line}<"
        round_count += 1
        round_header_found = true   # more rounds; continue
        round_body_found   = false
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif blank_found && line =~ /\[[a-z]{3} \d{1,2}\]/i   ## e.g. [Mar 13] or [May 5] with leading blank line; continue round
        puts "!!! bingo - continue round >#{line}<"
        round_header_found = true
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif blank_found && line =~ /First Legs|Second Legs/i
        puts "!!! bingo - continue round >#{line}<"
        round_header_found = true
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif line =~ /=-=-=-=/
        puts "!!! stop schedule; hit section marker (horizontal rule)"
        break;
      elsif line =~ /^\*{2}[^*]+\*{2}/   ## e.g. **FA Cup**
        puts "!!! stop schedule; hit section/stage header: #{line}"
        break
      else
        blank_found  = false
        puts "skipping line in schedule >#{line}<"
        next # continue
      end
    end
  end  # each line

  schedule = Schedule.from_string( new_txt )
  schedule.rounds = round_count

  schedule
end  # method find_schedule


def build_stat
  source       = nil
  authors      = nil
  last_updated = nil

  ### find source ref
  if @txt =~ /source: ([^ \n]+)/im
    source = $1.to_s
    puts "source: >#{source}<"
  end

  ##
  ## fix/todo: move authors n last updated  whitespace cleanup to sanitize - why? why not?? 

  if @txt =~ /authors?:\s+(.+?)\s+last updated:\s+(\d{1,2} [a-z]{3,10} \d{4})/im
    last_updated = $2.to_s   # note: save a copy first (gets "reset" by next regex)
    authors      = $1.to_s.strip.gsub(/\s+/, ' ' )  # cleanup whitespace; squish-style
    authors = authors.gsub( /[ ]*,[ ]*/, ', ' )    # prettify commas - always single space after comma (no space before)
    puts "authors: >#{authors}<"
    puts "last updated: >#{last_updated}<"
  end

  puts "*** !!! missing source"  if source.nil?
  puts "*** !!! missing authors n last updated"   if authors.nil? || last_updated.nil?

  sections = []

  ## count lines
  line_count = 0
  @txt.each_line do |line|
    line_count +=1

    ### find sections
    ## todo: add more patterns? how? why?
    if line =~ /####\s+(.+)/
      puts "  found section >#{$1}<"
      sections << $1.strip
    end
  end


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

  rec
end  ## method build_stat


def save( path )
  File.open( path, 'w' ) do |f|
    f.write @txt
  end
end  ## method save

end  ## class Page
end  ## module Rsssf


## add (shortcut) alias
RsssfPageStat = Rsssf::PageStat
RsssfPage     = Rsssf::Page


