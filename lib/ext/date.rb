
class Date

  COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def self.days_in_month(month, year = Time.now.year)
    return 29 if month == 2 && Date.gregorian_leap?(year)
    COMMON_YEAR_DAYS_IN_MONTH[month]
  end

  def days_in_year
		Date.parse("#{self.year}-12-31").strftime("%j").to_i
	end

	def day_in_year
		self.strftime("%j").to_i
  end



end