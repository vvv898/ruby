class AlphabeticalOrderIterator
  # У Ruby модуль Enumerable надає класам декілька методів для обходу і пошуку,
  # а також можливість сортування. Клас повинен забезпечувати метод `each`,
  # який передає наступні елементи колекції.
  include Enumerable

  # Цей атрибут вказує напрямок обходу.
  attr_accessor :reverse
  private :reverse

  # @return [Array]
  attr_accessor :collection
  private :collection

  # @param [Array] collection
  # @param [Boolean] reverse
  def initialize(collection, reverse: false)
    @collection = collection
    @reverse = reverse
  end

  def each(&block)
    return @collection.reverse.each(&block) if reverse

    @collection.each(&block)
  end
end

class WordsCollection
  # @return [Array]
  attr_accessor :collection
  private :collection

  def initialize(collection = [])
    @collection = collection
  end

  # Метод `iterator` повертає об'єкт ітератора, за замовчуванням ми
  # повертаємо ітератор у порядку зростання.
  def iterator
    AlphabeticalOrderIterator.new(@collection)
  end

  # @return [AlphabeticalOrderIterator]
  def reverse_iterator
    AlphabeticalOrderIterator.new(@collection, reverse: true)
  end

  # @param [String] item
  def add_item(item)
    @collection << item
  end
end

collection = WordsCollection.new
collection.add_item('First')
collection.add_item('Second')
collection.add_item('Third')

puts 'Прямий обхід:'
collection.iterator.each { |item| puts item }
puts "\n"

puts 'Зворотній обхід:'
collection.reverse_iterator.each { |item| puts item }