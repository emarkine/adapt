class Period
  attr_accessor :begin, :end

  def initialize(year = Time.now.year, month=nil)
    if month && !month.blank?
      self.begin = Time.parse("#{year}-#{month}-01 00:00:00")
      self.end = Time.parse("#{year}-#{month}-#{Date.days_in_month(month,year)} 23:59:59")
    else
      self.begin = Time.parse("#{year}-01-01  00:00:00")
      self.end = Time.parse("#{year}-12-31  23:59:59")
    end
  end

end