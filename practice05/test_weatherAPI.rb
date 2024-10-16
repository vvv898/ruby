require 'minitest/autorun'
require_relative 'weatherAPI' # Замініть на назву вашого файлу з основною програмою

class WeatherScriptTest < Minitest::Test
  def setup
    @api_key = 'YOUR_API_KEY' # Замініть на свій API-ключ
    @city = 'Kyiv'
  end

  def test_fetch_weather_data
    data = fetch_weather_data(@city, @api_key)
    assert data.is_a?(Hash), 'Результат повинен бути хешем'
    assert data['main'], 'Повинно бути поле main'
    assert data['wind'], 'Повинно бути поле wind'
  end

  def test_extract_weather_data
    sample_data = {
      'name' => 'Kyiv',
      'main' => { 'temp' => 15.0, 'humidity' => 80 },
      'wind' => { 'speed' => 5.0 }
    }
    weather_data = extract_weather_data(sample_data)
    assert_equal 'Kyiv', weather_data[:city]
    assert_equal 15.0, weather_data[:temperature]
    assert_equal 80, weather_data[:humidity]
    assert_equal 5.0, weather_data[:wind_speed]
  end

  def test_save_to_csv
    weather_data = { city: 'Kyiv', temperature: 15.0, humidity: 80, wind_speed: 5.0 }
    file_name = 'test_weather_data.csv'
    save_to_csv(file_name, weather_data)
    assert File.exist?(file_name), 'Файл повинен бути створений'

    csv_data = CSV.read(file_name, headers: true)
    assert_equal 'Kyiv', csv_data[0]['City']
    assert_equal '15.0', csv_data[0]['Temperature']
    assert_equal '80', csv_data[0]['Humidity']
    assert_equal '5.0', csv_data[0]['WindSpeed']
  ensure
    File.delete(file_name) if File.exist?(file_name) # Видалення тестового файлу після перевірки
  end
end