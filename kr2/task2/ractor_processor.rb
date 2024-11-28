class RactorProcessor
  def initialize
    @processor = Ractor.new do
      loop do
        data = Ractor.receive
        break if data == :done

        result = data.map { |n| n**2 }
        Ractor.yield(result)
      end
    end
  end

  def process(numbers)
    @processor.send(numbers)
    @processor.take
  end

  def shutdown
    @processor.send(:done)
  end
end