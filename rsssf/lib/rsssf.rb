
## 3rd party (our own)
require 'season/formats'   ## add season support
require 'webget'           ## incl. webget, webcache, webclient, etc.

require 'cocos'


## (old) 3rd party libs
##  require 'textutils'      ## used for File.read_utf8 etc.
## require 'fetcher'        ## used for Fetcher::Worker.new.fetch etc.


#######
##   add RsssfParser too
require 'rsssf/parser'    ## from rsssf-parser gem




## our own code
require_relative 'rsssf/version'    # note: let version always go first

require_relative 'rsssf/utils'      # include Utils - goes first

require_relative 'rsssf/download'

require_relative 'rsssf/convert'
require_relative 'rsssf/page'
require_relative 'rsssf/schedule'
require_relative 'rsssf/patch'

require_relative 'rsssf/reports/schedule'
require_relative 'rsssf/reports/page'

require_relative 'rsssf/repo'




#############
## add (shortcut) alias(es)
RsssfPage           = Rsssf::Page
RsssfPageConverter  = Rsssf::PageConverter
RsssfPageStat       = Rsssf::PageStat
RsssfPageReport     = Rsssf::PageReport

RsssfSchedule       = Rsssf::Schedule
RsssfScheduleStat   = Rsssf::ScheduleStat
RsssfScheduleReport = Rsssf::ScheduleReport

RsssfRepo           = Rsssf::Repo
RsssfUtils          = Rsssf::Utils
RsssfPatcher        = Rsssf::Patcher



## say hello
puts Rsssf.banner   ##  if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
