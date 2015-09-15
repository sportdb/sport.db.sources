# encoding: utf-8

module Rsssf

class Patcher

## e.g. 2008/09
##   note: also support 1999/2000
SEASON = '\d{4}\/(\d{2}|\d{4})'  ## note: use single quotes - quotes do NOT get escaped (e.g. '\d' => "\\d")

def patch_heading( txt, rxs, title )
  rxs.each do |rx|
    txt = txt.sub( rx ) do |match|
      match = match.gsub( "\n", '$$')  ## change newlines to $$ for single-line outputs/dumps
      puts "  found heading >#{match}<"
      "\n\n#### #{title}\n\n"
    end
  end
  txt
end

  
end # class Patcher
end  ## module Rsssf

## add (shortcut) alias
RsssfPatcher = Rsssf::Patcher

