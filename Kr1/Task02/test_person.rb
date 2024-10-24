require 'minitest/autorun'

class TestPerson < Minitest::Test
  def test_initialize
    person = Person.new("Alex", 30)
    assert_equal "Alex", person.name
    assert_equal 30, person.age
  end

  def test_age_plus_one
    person = Person.new("Alex", 30)
    person.age_plus_one
    assert_equal 31, person.age
  end

  def test_name_change
    person = Person.new("Alex", 30)
    person.name = "John"
    assert_equal "John", person.name
  end

  def test_age_change
    person = Person.new("Alex", 30)
    person.age = 35
    assert_equal 35, person.age
  end

  def test_invalid_name
    assert_raises(ArgumentError) { Person.new("", 30) }
  end

  def test_invalid_age
    assert_raises(ArgumentError) { Person.new("Alex", -5) }
  end

  def test_non_integer_age
    assert_raises(ArgumentError) { Person.new("Alex", "thirty") }
  end
end