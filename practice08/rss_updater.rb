require 'rss'
require 'json'
require 'open-uri'

# Функція для оновлення RSS-канал
уdef fetch_rss_feed(url)
  feed_items = []

  # Завантажуємо і парсимо RSS-канал
  URI.open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|
      feed_items << {
        title: item.title,
        link: item.link,
        description: item.description,
        pub_date: item.pubDate
      }
    end
  end

  feed_items
end

# Функція для оновлення списку RSS-каналів і збереження їх у JSON
def update_feeds(feed_urls, output_file)
  all_feeds = {}

  # Проходимо по кожному URL з масиву
  feed_urls.each do |url|
    all_feeds[url] = fetch_rss_feed(url)
  end

  # Записуємо всі дані у JSON-файл
  File.open(output_file, 'w') do |file|
    file.write(JSON.pretty_generate(all_feeds))
  end

  puts "RSS-канали збережено у #{output_file}"
end
