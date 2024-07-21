###
# to run use:
#
#  ruby  test/test_utils.rb



require_relative 'helper'

class TestUtils < Minitest::Test

  include RsssfUtils    ## e.g. year_from_name etc.

  def test_year

    ###########
    ## year_from_name
    ##    note: num <= 16   - assume 20xx for now from 00..16
    ##                      -  else  19xx
    assert_equal 2000, year_from_name( 'duit00' )
    assert_equal 2016, year_from_name( 'duit16' )

    assert_equal 1999, year_from_name( 'duit99' )

    assert_equal 2001, year_from_name( 'duit2001' )

    assert_equal 1964, year_from_name( 'duit64' )
    assert_equal 1965, year_from_name( 'duit1965' )
    assert_equal 2011, year_from_name( 'duit2011' )


    ####
    # year_from_file

    assert_equal 2000, year_from_file( 'duit00.txt' )
    assert_equal 2000, year_from_file( 'duit00.html' )
    assert_equal 2000, year_from_file( './duit00.txt' )
    assert_equal 2000, year_from_file( 'xxx/1998/xxx/duit00.txt' )

    assert_equal 2016, year_from_file( 'duit16.txt' )
    assert_equal 2016, year_from_file( 'duit16.html' )

    assert_equal 2001, year_from_file( 'duit2001.txt' )
    assert_equal 2001, year_from_file( 'duit2001.html' )
    assert_equal 2001, year_from_file( 'xx/1990s/1997/xxx/duit2001.txt' )

    assert_equal 2000, year_from_file( 'de-deutschland/tables/duit00.txt' )
    assert_equal 1964, year_from_file( 'de-deutschland/62/tables/duit64.txt' )    # check w/ numbers in path
    assert_equal 1999, year_from_file( 'de-deutschland/1977/tables/duit99.txt' )  # check w/ numbers in path
    assert_equal 1965, year_from_file( 'de-deutschland/tables/duit1965.txt' )
    assert_equal 2011, year_from_file( 'de-deutschland/tables/duit2011.txt' )

    assert_equal 2000, year_from_file( 'de-deutschland/tables/duit00.html' )
    assert_equal 1964, year_from_file( 'de-deutschland/62/tables/duit64.html' )    # check w/ numbers in path
    assert_equal 1999, year_from_file( 'de-deutschland/1977/tables/duit99.html' )  # check w/ numbers in path
    assert_equal 1965, year_from_file( 'de-deutschland/tables/duit1965.html' )
    assert_equal 2011, year_from_file( 'de-deutschland/tables/duit2011.html' )


    #######
    ## archive_dir_for_year
    ##  note:  year <= 2010  use season 2009-10

  
    assert_equal '2014-15',               archive_dir_for_season( '2014/15' )
    assert_equal '2010-11',               archive_dir_for_season( '2010/11' )
    assert_equal '2011',               archive_dir_for_season( '2011' )
    assert_equal '2010',               archive_dir_for_season( '2010' )

    assert_equal 'archive/2000s/2009-10', archive_dir_for_season( '2009/10' )
    assert_equal 'archive/2000s/2000-01', archive_dir_for_season( '2000/01' )
    assert_equal 'archive/2000s/2009', archive_dir_for_season( '2009' )
    assert_equal 'archive/2000s/2000', archive_dir_for_season( '2000' )
  
    assert_equal 'archive/1990s/1999-00', archive_dir_for_season( '1999/2000' )
    assert_equal 'archive/1990s/1999-00', archive_dir_for_season( '1999/00' )
    assert_equal 'archive/1990s/1998-99', archive_dir_for_season( '1998/99' )
    assert_equal 'archive/1990s/1999', archive_dir_for_season( '1999' )
    assert_equal 'archive/1990s/1990', archive_dir_for_season( '1990' )
  end

end # class TestUtils

