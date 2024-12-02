require 'rss'
require 'json'
require 'open-uri'

# Функція для завантаження RSS-каналу
def fetch_rss_feed(url)
  URI.open(url) do |rss|
    RSS::Parser.parse(rss, false)
  end
rescue StandardError => e
  puts "Помилка при завантаженні RSS: #{e.message}"
  nil
end

# Функція для перетворення RSS-даних у хеш
def rss_to_hash(feed)
  return nil unless feed

  {
    title: feed.channel.title,
    description: feed.channel.description,
    link: feed.channel.link,
    items: feed.items.map do |item|
      {
        title: item.title,
        link: item.link,
        pub_date: item.pubDate&.to_s
      }
    end
  }
end

# Функція для збереження даних у JSON
def save_to_json(data, file_path)
  File.open(file_path, 'w') do |file|
    file.write(JSON.pretty_generate(data))
  end
  puts "Дані збережено у #{file_path}"
end

# Функція для періодичного оновлення RSS-каналу
def update_rss_periodically(url, interval, output_file)
  loop do
    puts "Оновлення RSS-каналу: #{url}"
    feed = fetch_rss_feed(url)
    feed_data = rss_to_hash(feed)

    if feed_data
      # Завантаження попередніх даних з JSON, якщо вони є
      existing_data = File.exist?(output_file) ? JSON.parse(File.read(output_file)) : []

      # Додавання нових елементів до списку (якщо їх ще немає)
      new_items = feed_data[:items].reject do |new_item|
        existing_data.any? { |existing_item| existing_item['link'] == new_item[:link] }
      end

      # Якщо є нові елементи, додаємо їх до списку
      unless new_items.empty?
        existing_data.concat(new_items.map do |item|
          { 'title' => item[:title], 'link' => item[:link], 'pub_date' => item[:pub_date] }
        end)
        save_to_json(existing_data, output_file)
      else
        puts "Нові елементи не знайдено."
      end
    end

    # Чекаємо наступного оновлення
    puts "Чекаємо #{interval} секунд до наступного оновлення..."
    sleep(interval)
  end
end

# Список RSS-каналів
rss_feeds = [
  'https://feeds.bbci.co.uk/news/rss.xml'
]

# Основна програма
output_file = 'rss_data.json'
rss_feeds.each do |url|
  # Оновлюємо канали кожні 10 хвилин (600 секунд)
  update_rss_periodically(url, 10, output_file)
end