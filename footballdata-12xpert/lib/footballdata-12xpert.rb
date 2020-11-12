
## 3rd party libs / gems
require 'webget'

## sportdb libs / gems
require 'sportdb/importers'



###
# our own code
require 'footballdata-12xpert/version' # let version always go first

require 'footballdata-12xpert/config'
require 'footballdata-12xpert/download'
require 'footballdata-12xpert/convert'
require 'footballdata-12xpert/import'



module Footballdata12xpert

## helper to fix dates to use local timezone (and not utc/london time)
def self.fix_date( row, offset )
  return row    if row['Time'].nil?   ## note: time (column) required for fix

  col = row['Date']
  if col =~ /^\d{2}\/\d{2}\/\d{4}$/
    date_fmt = '%d/%m/%Y'   # e.g. 17/08/2002
  elsif col =~ /^\d{2}\/\d{2}\/\d{2}$/
    date_fmt = '%d/%m/%y'   # e.g. 17/08/02
  else
    puts "*** !!! wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
    ## todo/fix: add to errors/warns list - why? why not?
    exit 1
  end

  date = DateTime.strptime( "#{row['Date']} #{row['Time']}", "#{date_fmt} %H:%M" )
  date = date + offset

  row['Date'] = date.strftime( date_fmt )  ## overwrite "old"
  row['Time'] = date.strftime( '%H:%M' )
  row   ## return row for possible pipelining - why? why not?
end

end ## module Footballdata12xpert



###
##  add alternate aliases - why? why not?
Footballdata12Xpert   = Footballdata12xpert
Footballdata_12xpert  = Footballdata12xpert
Footballdata_12Xpert  = Footballdata12xpert


puts Footballdata12xpert.banner   # say hello
