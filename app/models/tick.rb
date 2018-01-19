class Tick < ActiveRecord::Base
  # establish_connection :remote_production unless Rails.env.production?
  # default_scope { order(:time) }
  scope :date, ->(date) { where('time >= ? and time < ?', date, date+1.day) }
  scope :time, ->(begin_time,end_time) { where('time >= ? and time < ?', begin_time, end_time) }
  belongs_to :fund

  validates :fund_id, :presence => true
  validates :time, :presence => true
  validates :rate, :presence => true
  has_and_belongs_to_many :bars

  # вставка дополнительных n тиков к началу переданного списка
  # TODO в случае, если запрашиваемые тики не находятся в базе, то запрос к Ticker для их создания
  def self.pre_add(ticks,n)
    t1 = ticks.first.time - n
    t2 = ticks.last.time
    Tick.where('fund_id = ? AND time >= ? AND time <= ?', ticks.last.fund.id, t1, t2)
  end

  def <=>(another)
    self.rate <=> another.rate
  end

  # def self.rate(fund,time)
  #   where('fund_id = ? AND time <= ?', fund.id, time).last.rate
  # end

  def amount
    (price * volume)
  end

  def date
    Date.parse(self.time.strftime('%Y-%m-%d'))
  end

  def to_s
    "#{fund.name} #{Time.at(time).strftime('%H:%M:%S')} #{format("%.#{fund.comma}f", rate)} #{volume}"
  end


end
