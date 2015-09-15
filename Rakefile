require 'hoe'
require './lib/rsssf/version.rb'

Hoe.spec 'rsssf' do

  self.version = Rsssf::VERSION

  self.summary = "rsssf - tools 'n' scripts for RSSSF (Rec.Sport.Soccer Statistics Foundation) archive data"
  self.description = summary

  self.urls    = ['https://github.com/sportdb/rsssf']

  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['logutils'],
    ['textutils'],
    ['fetcher'],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end
