require "parallel"

module Enumerable
  def parallel_map
    Parallel.map(self, in_processes: 8, &Proc.new)
  end

  def mode
    self.reduce(Hash.new(0)) { |acc, el| acc[el] += 1; acc }.max_by { |k, v| v }[0]
  end
end
