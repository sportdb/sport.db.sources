
## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

require 'cocos'


## (old) 3rd party libs
##  require 'textutils'      ## used for File.read_utf8 etc.
## require 'fetcher'        ## used for Fetcher::Worker.new.fetch etc.



## our own code
require_relative 'rsssf/version'    # note: let version always go first

require_relative 'rsssf/utils'      # include Utils - goes first
require_relative 'rsssf/html2txt'   # include Filters - goes first

require_relative 'rsssf/fetch'
require_relative 'rsssf/page'
require_relative 'rsssf/schedule'
require_relative 'rsssf/patch'

require_relative 'rsssf/reports/schedule'
require_relative 'rsssf/reports/page'

require_relative 'rsssf/repo'




#############
## add (shortcut) alias(es)
RsssfPageStat       = Rsssf::PageStat
RsssfPage           = Rsssf::Page
RsssfPageFetcher    = Rsssf::PageFetcher
RsssfFilters        = Rsssf::Filters
RsssfSchedule       = Rsssf::Schedule

RsssfRepo           = Rsssf::Repo
RsssfScheduleConfig = Rsssf::ScheduleConfig
RsssfScheduleStat   = Rsssf::ScheduleStat





## say hello
puts Rsssf.banner   ##  if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
