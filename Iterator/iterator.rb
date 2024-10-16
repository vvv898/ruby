class AlphabeticalOrderIterator
  include Enumerable

  attr_accessor :reverse
  private :reverse

  attr_accessor :collection
  private :collection

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
  attr_accessor :collection
  private :collection

  def initialize(collection = [])
    @collection = collection
  end

  def iterator
    AlphabeticalOrderIterator.new(@collection)
  end

  def reverse_iterator
    AlphabeticalOrderIterator.new(@collection, reverse: true)
  end

  def add_item(item)
    @collection << item
  end
end

collection = WordsCollection.new
collection.add_item('First')
collection.add_item('Second')
collection.add_item('Third')

puts 'Straight traversal:'
collection.iterator.each { |item| puts item }
puts "\n"

puts 'Reverse traversal:'
collection.reverse_iterator.each { |item| puts item }