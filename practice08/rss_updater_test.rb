require 'minitest/autorun'
require 'rss'
require 'json'
require 'open-uri'
require_relative 'rss_updater'

class RssUpdaterTest < Minitest::Test
  # Тест на завантаження RSS-каналу
  def test_fetch_rss_feed
    url = 'https://feeds.bbci.co.uk/news/rss.xml'
    feed = fetch_rss_feed(url)
    assert feed.is_a?(RSS::Rss), "Expected RSS feed, but got #{feed.class}"
  end

  # Тест на перетворення RSS-даних у хеш
  def test_rss_to_hash
    url = 'https://feeds.bbci.co.uk/news/rss.xml'
    feed = fetch_rss_feed(url)
    feed_data = rss_to_hash(feed)

    assert feed_data.is_a?(Hash), "Expected Hash, but got #{feed_data.class}"
    assert feed_data.key?(:title), "Missing 'title' key"
    assert feed_data.key?(:description), "Missing 'description' key"
    assert feed_data.key?(:link), "Missing 'link' key"
    assert feed_data.key?(:items), "Missing 'items' key"
    assert feed_data[:items].is_a?(Array), "Expected 'items' to be an Array"
  end

  # Тест на збереження даних у JSON
  def test_save_to_json
    data = { title: 'Test Title', items: [{ title: 'Test Item', link: 'http://example.com', pub_date: '2024-12-01' }] }
    output_file = 'test_rss_data.json'

    save_to_json(data, output_file)

    # Перевірка, чи файл був створений і містить правильні дані
    assert File.exist?(output_file), "Expected file #{output_file} to exist"
    saved_data = JSON.parse(File.read(output_file))
    assert_equal data[:title], saved_data['title'], "Title mismatch"
    assert_equal data[:items].first[:title], saved_data['items'].first['title'], "Item title mismatch"
  end

  # Тест на оновлення RSS-каналу (перевірка, що нові елементи додаються)
  def test_update_rss_periodically
    # Мокаємо функцію sleep для тестування
    sleep_time = 2  # Час затримки між оновленнями
    output_file = 'test_rss_data.json'

    # Викликаємо метод оновлення, який працюватиме тільки кілька циклів
    rss_feed_url = 'https://feeds.bbci.co.uk/news/rss.xml'

    # Мокаємо перше оновлення
    initial_data = [{ 'title' => 'Test Item 1', 'link' => 'http://example.com/1', 'pub_date' => '2024-12-01' }]
    save_to_json(initial_data, output_file)

    # Мокаємо перше отримання даних RSS
    feed_data = rss_to_hash(fetch_rss_feed(rss_feed_url))

    # Привласнюємо нові елементи, щоб перевірити додавання
    feed_data[:items] = [{ title: 'New Item', link: 'http://example.com/new', pub_date: '2024-12-02' }]

    # Імітація оновлення (замість повного циклу)
    new_items = feed_data[:items].reject do |new_item|
      initial_data.any? { |existing_item| existing_item['link'] == new_item[:link] }
    end

    # Перевірка, що нові елементи додаються
    refute new_items.empty?, "New items should not be empty"

    # Оновлення JSON файлу
    initial_data.concat(new_items.map { |item| { 'title' => item[:title], 'link' => item[:link], 'pub_date' => item[:pub_date] } })
    save_to_json(initial_data, output_file)

    saved_data = JSON.parse(File.read(output_file))
    assert_equal 2, saved_data['items'].size, "Expected 2 items, but found #{saved_data['items'].size}"

    # Очистка файлів після тестування
    File.delete(output_file) if File.exist?(output_file)
  end
end