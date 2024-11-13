require 'minitest/autorun'
require 'json'
require 'rss'
require 'open-uri'
require 'time'
require_relative 'rss_updater'

class RSSUpdaterTest < Minitest::Test
  TEST_RSS_XML = <<-XML
    <rss version="2.0">
      <channel>
        <title>Test RSS Feed</title>
        <link>http://example.com/</link>
        <description>This is a test feed</description>
        <item>
          <title>Test Item 1</title>
          <link>http://example.com/item1</link>
          <description>Test Description 1</description>
          <pubDate>Tue, 10 Oct 2023 10:00:00 +0000</pubDate>
        </item>
        <item>
          <title>Test Item 2</title>
          <link>http://example.com/item2</link>
          <description>Test Description 2</description>
          <pubDate>Wed, 11 Oct 2023 12:00:00 +0000</pubDate>
        </item>
      </channel>
    </rss>
  XML

  # Тест для функції fetch_rss_feed
  def test_fetch_rss_feed
    # Використовуємо StringIO для передачі тестового XML як потік
    rss_feed = StringIO.new(TEST_RSS_XML)
    RSS::Parser.stub :open, rss_feed do
      result = fetch_rss_feed("http://example.com/rss")
      assert_equal 2, result.size
      assert_equal "Test Item 1", result[0][:title]
      assert_equal "Test Description 1", result[0][:description]
      assert_equal "http://example.com/item1", result[0][:link]
      assert_equal Time.parse("Tue, 10 Oct 2023 10:00:00 +0000"), result[0][:pub_date]
    end
  end

  # Тест для функції update_feeds
  def test_update_feeds
    # Задаємо файл для збереження JSON
    output_file = "test_rss_feeds.json"
    
    # Використовуємо mock для URL-ів, щоб не робити реальних запитів
    RSS::Parser.stub :open, StringIO.new(TEST_RSS_XML) do
      update_feeds(["http://example.com/rss"], output_file)
    end

    # Перевіряємо, чи JSON-файл зберігся правильно
    saved_data = JSON.parse(File.read(output_file))
    assert saved_data.key?("http://example.com/rss")
    assert_equal 2, saved_data["http://example.com/rss"].size
    assert_equal "Test Item 1", saved_data["http://example.com/rss"][0]["title"]
  ensure
    # Видаляємо тестовий JSON-файл після тестування
    File.delete(output_file) if File.exist?(output_file)
  end
end
