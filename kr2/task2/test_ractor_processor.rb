require 'minitest/autorun'
require_relative 'ractor_processor'

class RactorProcessorTest < Minitest::Test
  def setup
    @processor = RactorProcessor.new
  end

  def teardown
    @processor.shutdown
  end

  def test_process_array
    input = [1, 2, 3, 4, 5]
    expected_output = [1, 4, 9, 16, 25]

    result = @processor.process(input)

    assert_equal expected_output, result, "Array was not processed correctly"
  end

  def test_empty_array
    input = []
    expected_output = []

    result = @processor.process(input)

    assert_equal expected_output, result, "Empty array should return empty"
  end

  def test_negative_numbers
    input = [-1, -2, -3]
    expected_output = [1, 4, 9]

    result = @processor.process(input)

    assert_equal expected_output, result, "Negative numbers were not processed correctly"
  end

  def test_large_numbers
    input = [1000, 2000, 3000]
    expected_output = [1_000_000, 4_000_000, 9_000_000]

    result = @processor.process(input)

    assert_equal expected_output, result, "Large numbers were not processed correctly"
  end
end
