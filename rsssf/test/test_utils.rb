


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


    #####
    ## year_to_season

    assert_equal '1998-99', year_to_season( 1999 )
    assert_equal '1999-00', year_to_season( 2000 )   ## todo: use 1999-2000 - why? why not??
    assert_equal '2000-01', year_to_season( 2001 )
    assert_equal '2014-15', year_to_season( 2015 )

    assert_equal '1999-00', year_to_season( 0 )
    assert_equal '1963-64', year_to_season( 64 )
    assert_equal '1998-99', year_to_season( 99 )
    assert_equal '1964-65', year_to_season( 1965 )
    assert_equal '2010-11', year_to_season( 2011 )


    #######
    ## archive_dir_for_year
    ##  note:  year <= 2010  use season 2009-10

    assert_equal 'archive/1990s/1998-99', archive_dir_for_year( 1999 )
    assert_equal 'archive/2000s/2000-01', archive_dir_for_year( 2001 )
    assert_equal '2014-15',               archive_dir_for_year( 2015 )


    assert true  ## everything ok if get here
  end

end # class TestUtils

