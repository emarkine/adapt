class Currency < ActiveRecord::Base
  belongs_to :country
  validates :name,
            :presence => true,
            :uniqueness => true
  validates :code,
            :presence => true,
            :uniqueness => true
  validates :country_id,
            :presence => true

  def self.USD
    Currency.find_by_code 'USD'
  end

  def self.EUR
    Currency.find_by_code 'EUR'
  end

  def rate(currency=nil)
    if currency
      fund = fund(currency)
      fund.ticks.last.rate if fund
    else
      (1.0 / fund.ticks.last.rate).round(5) if fund
    end
  end

  def time(currency=nil)
    if currency
      fund = fund(currency)
      fund.ticks.last.time if fund
    else
      fund.ticks.last.time if fund
    end
  end

  def fund(currency=nil)
    if currency
      fund_name = "#{self.code}#{currency.code}".downcase
      Fund.find_by_name fund_name
    else
      funds.first if funds.size == 1
    end
  end



end
