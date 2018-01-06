class Frame < ActiveRecord::Base
  LIST = %w( 1s 10s 30s 1m 2m 3m 5m 10m 30m 1h 1d)
  TOKENS = {
      's' => 1,
      'm' => (60),
      'h' => (60 * 60),
      'd' => (60 * 60 * 24)
  }

  def self.parse(input)
    time = 0
    input.scan(/(\d+)(\w)/).each do |amount, measure|
      time += amount.to_i * TOKENS[measure]
    end
    Frame.find time
  end

  def self._5s
    Frame.find_by_name '5s'
  end

  def size
    self.id
  end

  def self.names
    Frame.all.collect { |f| f.name }
  end

  def to_s
    "Frame[#{id}] #{name}"
  end

end
