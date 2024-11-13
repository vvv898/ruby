# string_length_sorter.rb

require 'json'

module StringLengthSorter
  class Sorter
    # Метод для сортування масиву рядків за довжиною
    def self.sort_by_length(strings)
      strings.sort_by(&:length)
    end
  end
end

if __FILE__ == $0
  require 'rspec/autorun'

  RSpec.describe StringLengthSorter::Sorter do
    it "сортує масив рядків за довжиною" do
      strings = ["apple", "pear", "banana", "kiwi"]
      sorted_strings = StringLengthSorter::Sorter.sort_by_length(strings)
      expect(sorted_strings).to eq(["kiwi", "pear", "apple", "banana"])
    end

    it "повертає порожній масив, якщо вхідний масив порожній" do
      expect(StringLengthSorter::Sorter.sort_by_length([])).to eq([])
    end
  end
end
