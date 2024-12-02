require 'minitest/autorun'
require 'csv'
require_relative 'weather_api'

class TestWeatherAPI < Minitest::Test
  # Тестуємо запит до API
  def test_fetch_weather_success
    result = WeatherAPI.fetch_weather('London')
    refute_nil result
    assert_instance_of Hash, result
    assert_equal 'London', result['name']
  end

  def test_fetch_weather_invalid_city
    result = WeatherAPI.fetch_weather('InvalidCityName')
    assert result.key?('error')
    assert result.key?('code')
    assert_equal '404', result['code']
  end
end

class TestWeatherData < Minitest::Test
  def setup
    @valid_data = {
      'name' => 'London',
      'main' => { 'temp' => 15.0, 'humidity' => 60 },
      'wind' => { 'speed' => 5.0 },
      'weather' => [{ 'description' => 'clear sky' }]
    }

    @invalid_data = { 'error' => 'City not found' }
  end

  def test_valid_data_extraction
    weather_data = WeatherData.new(@valid_data)
    assert weather_data.valid?

    extracted = weather_data.extract
    refute_nil extracted
    assert_equal 'London', extracted[:city]
    assert_equal 15.0, extracted[:temperature]
    assert_equal 60, extracted[:humidity]
    assert_equal 5.0, extracted[:wind_speed]
    assert_equal 'clear sky', extracted[:weather_description]
  end

  def test_invalid_data_extraction
    weather_data = WeatherData.new(@invalid_data)
    refute weather_data.valid?
    assert_nil weather_data.extract
  end
end

class TestWeatherCSV < Minitest::Test
  def setup
    @sample_data = {
      city: 'London',
      temperature: 15.0,
      humidity: 60,
      wind_speed: 5.0,
      weather_description: 'clear sky'
    }
    @file_name = 'test_weather_output.csv'
  end

  def test_csv_creation
    WeatherCSV.save(@sample_data, @file_name)
    assert File.exist?(@file_name)

    csv_data = CSV.read(@file_name, headers: true).first
    assert_equal 'London', csv_data['city']
    assert_equal '15.0', csv_data['temperature']
    assert_equal '60', csv_data['humidity']
    assert_equal '5.0', csv_data['wind_speed']
    assert_equal 'clear sky', csv_data['weather_description']
  ensure
    File.delete(@file_name) if File.exist?(@file_name)
  end
end