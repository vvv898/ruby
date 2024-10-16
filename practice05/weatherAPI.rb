require 'net/http'
require 'json'
require 'csv'

# Функція для отримання даних про погоду для заданого міста
def fetch_weather_data(city, api_key)
  url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric")
  response = Net::HTTP.get(url)
  JSON.parse(response)
end

# Функція для витягнення ключових даних
def extract_weather_data(data)
  {
    city: data['name'],
    temperature: data['main']['temp'],
    humidity: data['main']['humidity'],
    wind_speed: data['wind']['speed']
  }
end

# Функція для збереження даних у CSV файл
def save_to_csv(file_name, weather_data)
  CSV.open(file_name, 'w', write_headers: true, headers: %w[City Temperature Humidity WindSpeed]) do |csv|
    csv << [weather_data[:city], weather_data[:temperature], weather_data[:humidity], weather_data[:wind_speed]]
  end
end

# Основна програма
api_key = 'YOUR_API_KEY' # Замініть на свій API-ключ
city = 'Kyiv' # Місто для запиту

begin
  raw_data = fetch_weather_data(city, api_key)
  weather_data = extract_weather_data(raw_data)
  save_to_csv('weather_data.csv', weather_data)
  puts "Save in weather_data.csv"
rescue StandardError => e
  puts "Error: #{e.message}"
end