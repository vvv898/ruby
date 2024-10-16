class Knapsack
  def initialize(weights, values, capacity)
    @weights = weights
    @values = values
    @capacity = capacity
    @num_items = weights.length
  end

  def solve
    dp = Array.new(@num_items + 1) { Array.new(@capacity + 1, 0) }

    (1..@num_items).each do |i|
      (1..@capacity).each do |w|
        if @weights[i - 1] <= w
          dp[i][w] = [dp[i - 1][w], dp[i - 1][w - @weights[i - 1]] + @values[i - 1]].max
        else
          dp[i][w] = dp[i - 1][w]
        end
      end
    end

    selected_items = find_selected_items(dp)
    [dp[@num_items][@capacity], selected_items]
  end

  private

  def find_selected_items(dp)
    selected_items = []
    w = @capacity
    @num_items.downto(1) do |i|
      if dp[i][w] != dp[i - 1][w]
        selected_items << i - 1
        w -= @weights[i - 1]
      end
    end
    selected_items
  end
end