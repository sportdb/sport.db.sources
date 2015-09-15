# encoding: utf-8

## stdlibs
require 'pp'
require 'yaml'
require 'uri'


## 3rd party libs
require 'textutils'      ## used for File.read_utf8 etc.
require 'fetcher'        ## used for Fetcher::Worker.new.fetch etc.


## our own code
require 'rsssf/version'    # note: let version always go first




## say hello
puts Rsssf.banner   if defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG
