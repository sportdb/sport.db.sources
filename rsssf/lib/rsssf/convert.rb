
module Rsssf
class PageConverter
 
    ## convenience helper
     def self.convert( html, url: )
           @@converter ||= new   ## use a "shared" built-in converter
           @@converter.convert( html, url: url )
     end
    
  ##
  ##  add anchor: options or such 
  ##    lets you toggle adding anchors (§premier etc.) - why? why not?  
  
  def convert( html, url: )
    ### todo/fix: first check if html is all ascii-7bit e.g.
    ## includes only chars from 64 to 127!!!
  
    ## normalize newlines
    ##   remove \r (form feed) used by Windows; just use \n (new line)
    html = html.gsub( "\r", '' )
  
    ## check for html entities
    html = html.gsub( "&auml;", 'ä' )
    html = html.gsub( "&ouml;", 'ö' )
    html = html.gsub( "&uuml;", 'ü' )
    html = html.gsub( "&Auml;", 'Ä' )
    html = html.gsub( "&Ouml;", 'Ö' )
    html = html.gsub( "&Uuml;", 'Ü' )
    html = html.gsub( "&szlig;", 'ß' )
  
    ## typos / autofix - keep - why? why not?
    html = html.gsub( "&oulm;", 'ö' )    ## support typo in entity (&ouml;)
    html = html.gsub( "&uml;",  'ü' )    ## support typo in entity (&uuml;) - why? why not?
    html = html.gsub( "&slig;", "ß" )    ## support typo in entity (&szlig;)
    html = html.gsub( "&aaacute;", "á" )  ## typo for &aacute; 
   
    
    html = html.gsub( "&Eacute;", 'É' )
    html = html.gsub( "&oslash;", 'ø' )
    html = html.gsub( "&atilde;", 'ã' )
    html = html.gsub( "&otilde;", 'õ' )
    html = html.gsub( "&ocirc;", 'ô' )

    entities = %w[
À   &Agrave;
Á   &Aacute;
Â   &Acirc;
Ã   &Atilde;
Ä   &Auml;
Å   &Aring;
à   &agrave;
á   &aacute;
â   &acirc;
ã   &atilde;
ä   &auml;
å   &aring;
Æ   &AElig;
æ   &aelig;
ß   &szlig;
Ç   &Ccedil;
ç   &ccedil;
È   &Egrave;
É   &Eacute;
Ê   &Ecirc;
Ë   &Euml;
è   &egrave;
é   &eacute;
ê   &ecirc;
ë   &euml;
Ì   &Igrave;
Í   &Iacute;
Î   &Icirc;
Ï   &Iuml;
ì   &igrave;
í   &iacute;
î   &icirc;
ï   &iuml;
Ñ   &Ntilde;
ñ   &ntilde;
Ò   &Ograve;
Ó   &Oacute;
Ô   &Ocirc;
Õ   &Otilde;
Ö   &Ouml;
ò   &ograve;
ó   &oacute;
ô   &ocirc;
õ   &otilde;
ö   &ouml;
Ø   &Oslash;
ø   &oslash;
Ù   &Ugrave;
Ú   &Uacute;
Û   &Ucirc;
Ü   &Uuml;
ù   &ugrave;
ú   &uacute;
û   &ucirc;
ü   &uuml;
Ý   &Yacute;
ý   &yacute;
ÿ   &yuml;

<    &lt;
>    &gt;
&    &amp;
©    &copy;
®    &reg;

Š    &#352; 
š    &#353; 
č    &#269; 
ć    &#263; 
Ž    &#381;
’    &#8217;
  ]



    entities.each_slice(2) do |str, entity|
       html = html.gsub( entity, str )
    end



    ##############
    ## check for more entities
    ##   limit &---; to length 10 - why? why not?
    html = html.gsub( /&[^; ]{1,10};/) do |match|
  
      match =   if match == '&#307;'   ## use like Van D&#307;k  -> Van Dijk
                  'ij'
                else
                  msg = "found unencoded html entity #{match}"
                  puts "*** WARN - #{msg}"
                  log( msg )  ## log too (see log.txt)

                  match   ## pass through as is (1:1)
                end
  
      match   
    end
    ## todo/fix: add more entities
  
###################################
 ### smart quotes quick fixes   
### convert all "smart" quote to (standard) single quotes
##  D´Alessandro   =>  D'Alessandro 
  
    html = html.gsub( '´', "'" )

    
  
    txt   = html_to_txt( html )
  
    header = <<EOS
  <!--
     source: #{url}
    -->
  
EOS
  
    header+txt  ## return txt w/ header
  end  ## method convert
  

  ## todo/fix - use generic heading regex for all h2/h3/h4 etc.
  ##  exclude h1 - why? why not?
  ## note - include leading and trailing spaces !!!
  ##
  ## note  - for content use non-greedy to allow 
  ##              match of tags inside content too
  HEADING2_RE = %r{ \s*
                     <H2>
                       (?<title>.+?)
                     </H2>
                     \s*
                   }imx
                   
  HEADING4_RE = %r{ \s*
                   <H4>
                     (?<title>.+?)
                   </H4>
                   \s*
                 }imx

  def replace_h2( html )
     html.gsub( HEADING2_RE ) do |_|
        m = Regexp.last_match
        puts " replace heading 2 (h2) >#{m[:title]}<"
        "\n\n## #{m[:title]}\n\n"    ## note: make sure to always add two newlines
     end
  end

  def replace_h4( html )
    html.gsub( HEADING4_RE ) do |_|
       m = Regexp.last_match
       puts " replace heading 4 (h4) >#{m[:title]}<"
       "\n\n#### #{m[:title]}\n\n"    ## note: make sure to always add two newlines
    end
 end


 def squish( str )
    ## squish more than one white space to one space
    str.gsub( /[ \r\t\n]+/, ' ' )
 end


 def patch_about( html )
  # <A name=about>
  #  <H2>About this document</H2></A> 
  #  or
  # <A NAME="about"><H2>About this document</H2></A>
  #   => change to (possible?)
  #  <H2><A name=about>About this document</A></H2>

   html.sub( %r{<A [ ] name=(about|"about")> \s*
              <H2>About [ ] this [ ] document</H2></A>
             }ixm,
              "<H2><A name=about>About this document</A></H2>"
            )
 end

  # <a name="sa">Série A</a>
  # <a name="sd">Série D</a> 

  # <A name=about>
  #  <H2>About this document</H2></A>
  #   => change to (possible?)
  #  <H2><A name=about>About this document</A></H2>
  #
  #
  # <h4><a name="cb">Copa do Brasil</a></h4>

   ## note  - for content use non-greedy to allow 
   ##              match of tags inside content too

  A_NAME_RE = %r{<A [ ]+ NAME [ ]* =
                     (?<name>[^>]+?) 
                  >
                     (?<title>.+?) 
                  </A>
                }imx
       
  # <a href="#sa">Série A</a><br>
  # 
  #  <A href="http://www.rsssf.org/">Rec.Sport.Soccer 
  #        Statistics Foundation</A> 
  #  <A href="http://www.rsssfbrasil.com">RSSSF 
  #    Brazil</A> 
  #
  #  and Daniel Dalence (<A
  #   href="mailto:danielballack@terra.com.br">danielballack@terra.com.br</A>)


  A_HREF_RE = %r{<A \s+ HREF [ ]* = 
                    (?<href>[^>]+?)
                  >
                    (?<title>.+?)
                  <\/A>
                }imx              


def replace_a_href( html )
  ## remove anchors (a href)
  #    note: heading 4 includes anchor (thus, let anchors go first)
  #  note: <a \newline href is used for authors email - thus incl. support for newline as space
  html.gsub( A_HREF_RE ) do |match|   ## note: use .+? non-greedy match
    m = Regexp.last_match
    href  = m[:href].gsub( /["']/, '' ).strip   ## remove ("" or '')
    title = m[:title].strip   ## note: "save" caputure first; gets replaced by gsub (next regex call)


    ## e.g.
    ##  ‹Larsen23@gmx.de, see page mailto:Larsen23@gmx.de›
    ##  ‹danielballack@terra.com.br, see page mailto:danielballack@terra.com.br›
    ##  ‹zja70@aol.com, see page mailto:zja70@aol.com›)
    if href.start_with?( 'mailto:')
      puts " blank mailto  -  anchor (a) href >#{href}, >#{title}<"
      '‹mailto›'   ## delete/remove email
    else
      puts " replace anchor (a) href >#{href}, >#{title}<"

      ## convert href to xref
      xref = if href.start_with?('#')    ## in-page ref
              ", see §#{href[1..-1]}"
             elsif href.start_with?( /https?:/ )            ## external page ref
               ## skip - keep empty - why? why not? (or add url domain?)
               ''
             else
               ## hack - check for some custom excludes  
               if title.start_with?( 'Rec.Sport.Soccer' )
                    ## skip - keep empty
                    '' 
               else   
                 ## strip (ending)  .htm|html
                 ", see page #{href.sub( /\.html?$/,'')}"
               end
             end

      "‹#{squish(title)}#{xref}›"
    end
  end
end

def replace_a_name( html )
  ##
  ## remove (named) anchors
  html.gsub( A_NAME_RE ) do |match|   ## note: use .+? non-greedy match
    m = Regexp.last_match
    name = m[:name].gsub( /["']/, '' ).strip   ## remove ("" or '')
    title = m[:title].strip   ## note: "save" caputure first; gets replaced by gsub (next regex call)
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace anchor (a) name >#{name}<, >#{title}<    -    >#{match}<"
  

   ##
   ## todo - report WARN if title incl. tags
   ##    assumes text only for now - why? why not?
   ##  add a name inside heading !!!
   ##  do NOT add heading inside a name !!!

    "#{title}  ‹§#{name}›"   ## note - use two spaces min (between title & name)
  end
end


EMAIL_RE = %r{ \s*
\(
 [a-z][a-z0-9_]+
   @[a-z]+(\.[a-z]+)+
 \)
}imx   


def remove_emails( html )
  ### remove converted ("blineded") mailto anchors
  ##  note   usually inside () e.g.
  ##    (‹mailto›) 
  ##   plus slurp up all leading whitespace (incl. newline) - why? why not?
  html = html.gsub( /\s*
                      \(‹mailto›\)
                     /xm, '' )
  
   ###
   ##  remove "regular emails too e.g.
   ##
   ## Thanks to Marcelo Leme de Arruda (___@___.__.br),
   ##  Ricardo FF Pontes (___@____.com), 
   ## Santiago Reis (____@____.com.br),
   ## Marcos Lacerda Queiroz (___@____.com.br)
   ##  etc.

  ## check for "free-standing e.g. on its own line" emails only for now
   html = html.gsub( EMAIL_RE ) do |match|
    puts "removing  email >#{match}<"
    ''   
   end
   html
end



def html_to_txt( html )

###
#   todo: check if any tags (still) present??


  ## cut off everything before body
  html = html.sub( /.+?<BODY>\s*/im, '' )

  ## cut off everything after body (closing)
  html = html.sub( /<\/BODY>.*/im, '' )

  html = patch_about( html )

  ## remove cite
  html = html.gsub( /<CITE>([^<]+)<\/CITE>/im ) do |_|
    puts " remove cite >#{$1}<"
    "#{$1}"
  end

  html = html.gsub( /\s*<HR>\s*/im ) do |match|
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace horizontal rule (hr) - >#{match}<"
    "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n"    ## check what hr to use use  - . - . - or =-=-=-= or somehting distinct?
  end

  ## replace break (br)
  ## note: do NOT use m/multiline for now - why? why not??
  html = html.gsub( /<BR>\s*/i ) do |match|    ## note: include (swallow) "extra" newline
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace break (br) - >#{match}<"
    "\n"
  end


  
  html = replace_a_href( html )
  ##  note a name="about" includes more a hrefs etc.
  #    let it go first (before a href)
  html = replace_a_name( html )



  ## replace paragrah (p)
  html = html.gsub( /\s*<P>\s*/im ) do |match|    ## note: include (swallow) "extra" newline
    match = match.gsub( "\n", '$$' )  ## make newlines visible for debugging
    puts " replace paragraph (p) - >#{match}<"
    "\n\n"
  end
  html = html.gsub( /<\/P>/i, '' )  ## replace paragraph (p) closing w/ nothing for now

  ## remove i
  html = html.gsub( /<I>([^<]+)<\/I>/im ) do |_|
    puts " remove italic (i) >#{$1}<"
    "#{$1}"
  end


  html = replace_h2( html )
  html = replace_h4( html )




  ## remove b   - note: might include anchors (thus, call after anchors)
  html = html.gsub( /<B>([^<]+)<\/B>/im ) do |_|
    puts " remove bold (b) >#{$1}<"
    "**#{$1}**"
  end

  ## replace preformatted (pre)
  html = html.gsub( /<PRE>|<\/PRE>/i ) do |_|
    puts " replace preformatted (pre)"
    ''  # replace w/ nothing for now (keep surrounding newlines)
  end

=begin
  puts
  puts
  puts "html:"
  puts html[0..2000]
  puts "-- snip --"
  puts html[-1000..-1]   ## print last hundred chars
=end


  html = remove_emails( html )


  ## cleanup whitespaces
  ##   todo/fix:  convert newline in space first
  ##                and than collapse spaces etc.!!!
  txt = String.new
  html.each_line do |line|
     line = line.gsub( "\t", '  ' ) # replace all tabs w/ two spaces for nwo
     line = line.rstrip             # remove trailing whitespace (incl. newline/formfeed)

     txt << line
     txt << "\n"
  end

  txt
end # method html_to_text



###
# more helpers
def log( msg )
  ## append msg to ./logs.txt  
  ##     use ./errors.txt - why? why not?
  File.open( './logs.txt', 'a:utf-8' ) do |f|
    f.write( msg )
    f.write( "\n" ) 
  end
end



end # module PageConverter
end # module Rsssf

