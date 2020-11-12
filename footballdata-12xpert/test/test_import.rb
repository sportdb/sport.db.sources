###
#  to run use
#     ruby -I ./lib -I ./test test/test_import.rb


require 'helper'

class TestImport < MiniTest::Test

  def setup
    ## SportDb::Import.config.clubs_dir = '../../../openfootball/clubs'

    SportDb.connect( adapter:  'sqlite3',
                     database: ':memory:' )

    ## build database schema / tables
    SportDb.create_all
  end


  def test_import_at
    Footballdata12xpert.import( 'at' )
  end

  def test_import_eng
    Footballdata12xpert.import( 'eng', start: '2020/21' )
  end

  def xxx_test_import_all     ## note: test disabled for now
     Footballdata12xpert.import
  end

end # class TestImport
