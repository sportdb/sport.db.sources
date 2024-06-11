###
#  to run use
#     ruby -I ./lib -I ./test test/test_download.rb


require_relative  'helper'

class TestDownload < Minitest::Test

  def test_sources
    pp Footballdata12xpert::SOURCES_I
    pp Footballdata12xpert::SOURCES_II
  end

  def test_download_at
    Footballdata12xpert.download( 'at' )
  end

  def test_download_eng
    Footballdata12xpert.download( 'eng', start: '2020/21' )
  end

  def xxx_test_download_all   ## note: test disabled for now
    Footballdata12xpert.download
  end

end # class TestDownload
