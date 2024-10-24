require_relative 'leap_year'
require 'minitest/autorun'

class TestLeapYear < Minitest::Test
  def test_leap_year_2000
    assert_equal "2000 is a leap year", leap_year(2000)
  end

  def test_leap_year_1900
    assert_equal "1900 is not a leap year", leap_year(1900)
  end

  def test_leap_year_2020
    assert_equal "2020 is a leap year", leap_year(2020)
  end

  def test_leap_year_2021
    assert_equal "2021 is not a leap year", leap_year(2021)
  end
end