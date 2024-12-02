require 'net/http'
require 'json'
require 'csv'

class WeatherAPI
  API_KEY = '5ec7af91bf2349c5dbe5f36141e6e0b9'
  API_URL = 'http://api.openweathermap.org/data/2.5/weather'

  def self.fetch_weather(city)
    url = URI("#{API_URL}?q=#{URI.encode_www_form_component(city)}&appid=#{API_KEY}&units=metric")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      { 'error' => response.message, 'code' => response.code }
    end
  end
end

class WeatherData
  def initialize(data)
    @data = data
  end

  def valid?
    required_keys = %w[name main wind weather]
    required_keys.all? { |key| @data.key?(key) }
  end

  def extract
    return nil unless valid?

    {
      city: @data['name'],
      temperature: @data.dig('main', 'temp'),
      humidity: @data.dig('main', 'humidity'),
      wind_speed: @data.dig('wind', 'speed'),
      weather_description: @data.dig('weather', 0, 'description') || 'Unknown'
    }
  end
end

class WeatherCSV
  def self.save(data, filename = 'weather_output.csv')
    CSV.open(filename, 'a+', headers: data.keys, write_headers: !File.exist?(filename)) do |csv|
      csv << data.values
    end
  end
end

class WeatherApp
  def self.display(data)
    puts "City: #{data[:city]}"
    puts "Temperature: #{data[:temperature]}°C"
    puts "Humidity: #{data[:humidity]}%"
    puts "Wind Speed: #{data[:wind_speed]} m/s"
    puts "Weather Description: #{data[:weather_description]}"
  end

  def self.run
    puts 'Enter the name of the city in English to get the weather:'
    city = gets.chomp

    raw_data = WeatherAPI.fetch_weather(city)
    weather_data = WeatherData.new(raw_data)
    extracted_data = weather_data.extract

    if extracted_data.nil?
      puts 'Error retrieving data. Please check the city name.'
    else
      display(extracted_data)
      WeatherCSV.save(extracted_data)
      puts 'Data has been saved to weather_output.csv'
    end
  end
end

WeatherApp.run if __FILE__ == $0