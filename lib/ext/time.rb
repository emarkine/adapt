require 'active_support/core_ext/numeric'

class Time

	def add_time_now
		now = Time.now
		mktime(self.year, self.month, self.day, now.hour, now.min, now.sec)
	end

	def days_in_year
		Date.parse("#{self.year}-12-31").strftime('%j').to_i
	end

	def day_in_year
		self.strftime('%j').to_i
  end

  def to_stime
    self.strftime('%T')
  end

  def to_sdate
    self.strftime('%F')
  end

  def to_sdt
    self.strftime('%F %T')
  end

  def before?(str)
    self < Time.parse(str)
  end

  def after?(str)
    self > Time.parse(str)
  end

  def to_ms
    (self.to_f * 1000.0).to_i
  end

  # Time#round already exists with different meaning in Ruby 1.9
  def round_off(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end


end