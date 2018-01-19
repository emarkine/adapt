class TimeParser
  LIST = ['1s', '10s', '30s', '1m', '2m', '3m', '5m', '10m', '30m', '1h', '1d']
  TOKENS = {
      's' => 1,
      'm' => (60),
      'h' => (60 * 60),
      'd' => (60 * 60 * 24)
  }

  attr_reader :time

  def initialize(input)
    @input = input
    @time = 0
    parse
  end

  def self.parse(frame)
    TimeParser.new(frame).time
  end

  def self.to_s_m_h_d(sec)
    case sec
      when 1
        '1s'
      when 10
        '10s'
      when 30
        '30s'
      when 60
        '1m'
      when 120
        '2m'
      when 180
        '3m'
      when 300
        '5m'
      when 600
        '10m'
      when 1800
        '30m'
      when 3600
        '1h'
      when 86400
        '1d'
    end
  end


  def self.name(frame)
    if frame == '1m'
      '60 seconds'
    elsif i = frame.index('s')
      "#{frame[0...i]} seconds"
    elsif i = frame.index('m')
      "#{frame[0...i]} minutes"
    elsif i = frame.index('h')
      "#{frame[0...i]} hour"
    elsif i = frame.index('d')
      "#{frame[0...i]} day"
    end
  end

  def parse
    @input.scan(/(\d+)(\w)/).each do |amount, measure|
      @time += amount.to_i * TOKENS[measure]
    end
  end

  def self.previous(frame)
    LIST[LIST.index(frame)-1]
  end

  def self.list(index=0)
    LIST[index]
  end


end
