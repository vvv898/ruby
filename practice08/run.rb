require_relative 'rss_updater'

# Список URL-каналів
feed_urls = [
  'https://example.com/rss_feed_1.xml',
  'https://example.com/rss_feed_2.xml'
]

# Вихідний файл для збереження RSS у JSON
output_file = 'rss_feeds.json'

# Оновлення та збереження RSS-каналів у JSON-файл
update_feeds(feed_urls, output_file)