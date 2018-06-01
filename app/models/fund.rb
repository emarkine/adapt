class Fund < ActiveRecord::Base
  # include Store
  default_scope { order(:show_index) }
  scope :watches, -> { where(watch: true) }

  belongs_to :currency
  # has_many :brokers, through: :broker_fund_names
  # has_and_belongs_to_many :binary_types
  # has_and_belongs_to_many :indicators
  has_many :orders

  has_many :ticks
  has_many :bars
  # has_many :nerves

  attr_accessor :broker

  validates :name,
            :presence => true,
            :uniqueness => true


  def self.init(session)
    if session[:fund]
      fund = Fund.find(session[:fund])
    else
      fund = Fund.watches.first
      session[:fund] = fund.id
    end
    fund
  end

    def to_s
      # "Fund[#{name}], indicators: #{indicators.size}]"
      # "Fund[#{name}] #{currency.sign}#{rate}"
      "Fund[#{name}]"
    end

  def <=>(other)
    self.name <=> other.name
  end

  # время последнего тика
  # def time
  #   self.ticks.last.time
  # end

  # последний тик
  def tick(time=nil)
    if time # выбираем тики за последние 10 секунд
      ticks.where('ms >= ? AND ms <= ?', (time-10).to_ms, time.to_ms).last
    else
      ticks.last
    end
  end

  # последний бар
  def bar(time=nil)
    if time
      # начинаем с 5s
      bar = bars.where('frame_id = 5 AND open_time > ? AND close_time <= ?', time-10, time).last
      return bar if bar
      # пробуем с 1m
      bar = bars.where('frame_id = 60 AND open_time > ? AND close_time <= ?', time-120, time).last
      return bar if bar
    end
    bars.last
  end

  # текущий (последний) курс на основе 5s баров
  def rate(time=nil)
    unless time
      tick = Tick.where(fund: self).last
      if self.name != 'gold' && (tick && (tick.time.to_i > (Time.now.to_i - 5))) # разница меньше 5s с текущим временем (плюс по золоту фигачит расческа)
        tick.rate
      else
        bar = Bar.where(fund: self, frame: Frame._5s).last
        bar = Bar.where(fund: self, frame: Frame._1m).last unless bar
        bar.close if bar
      end
    else
      tick = tick(time)
      if tick
        # puts "fund.rate.tick[#{tick.time.to_sdt}] #{tick.rate} #{Time.now.to_ms - rtime} ms" if @print
        tick.rate
      else
        bar = bar(time)
        # puts "fund.rate.bar[#{bar.close_time.to_sdt} #{bar.frame.name}] #{bar.close} #{Time.now.to_ms - rtime} ms" if @print
        bar.close if bar
      end
    end
  end

  # текущий курс в зависимости от переданной даты и времени
  def rate_(time=nil)
    @print = false
    rtime = Time.now.to_ms if @print
    puts "request: #{time.to_sdt}" if time && @print
    tick = tick(time)
    if tick
      puts "fund.rate.tick[#{tick.time.to_sdt}] #{tick.rate} #{Time.now.to_ms - rtime} ms" if @print
      tick.rate
    else
      bar = bar(time)
      puts "fund.rate.bar[#{bar.close_time.to_sdt} #{bar.frame.name}] #{bar.close} #{Time.now.to_ms - rtime} ms" if @print
      bar.close if bar
    end
    # if time
    #   # rtime = Time.now.to_ms
    #   # all_ticks = ticks.where('ms >= ? and ms <= ?', (time-2).to_ms, time.to_ms)
    #   # puts "Fund.tick.all[#{all_ticks.size}]: #{Time.now.to_ms - rtime} ms\n"
    #
    #   # выбираем тики за последние 10 секунд
    #   list = Tick.where('fund_id =? AND ms >= ? AND ms <= ?', self.id, (time-10).to_ms, time.to_ms)
    #   puts "Fund.rate.list[#{list.size}]: #{Time.now.to_ms - rtime} ms" if @print
    #   unless list.empty? # если список не пуст
    #     puts "Fund.rate.tick[#{list.last.time.to_sdt} #{list.last.rate}] #{Time.now.to_ms - rtime} ms" if @print
    #     return list.last.rate # возвращаем значение последнего тика
    #   else # читаем 5s бар
    #     bar = Bar.where('frame_id = 5 AND fund_id = ? AND open_time > ? AND close_time <= ? ',
    #                     self.id, time, time ).last
    #     puts "Fund.rate.bar[#{bar.time.to_sdt} #{bar.close}] #{Time.now.to_ms - rtime} ms" if @print
    #     return bar.close
    #   end
    #   rtime = Time.now.to_ms
    #   tick = list.last
    #   # tick = Tick.where('fund_id = ? and time >= ?', self.id, time).first
    #   # tick = Tick.find_by_sql("fund_id = #{self.id} and time > #{time.to_s(:db)}")
    #   puts "Fund.tick.last: #{Time.now.to_ms - rtime} ms" if @print
    # else
    #   return ticks.last.rate
    # end
    # # puts "Fund.tick[#{tick.time.to_sdt}] #{tick.rate}" if @print
    # # tick.rate
  end

  def broker(broker_id)
    @broker = Broker.find broker_id
  end

  def broker_id
    @broker.id if @broker
  end

  # поиск фонда по строке
  def self.get(meta)
    return Fund.find_by_name('aex') if meta.upcase.index('EOE') || meta.index('AEX 25')
    return Fund.find_by_name('djia') if meta.upcase.index('DOW JONES')
    return Fund.find_by_name('nq') if meta.upcase.index('NASDAQ')
    return Fund.find_by_name('es') if meta.upcase.index('S&P')
    return Fund.find_by_name('ftse') if meta.upcase.index('FTSE')
    return Fund.find_by_name('ftse mib') if meta.upcase.index('FTSE MIB')
    return Fund.find_by_name('fdax') if meta.upcase.index('DAX')
    return Fund.find_by_name('bel') if meta.upcase.index('BEL-20')
    return Fund.find_by_name('nikkei') if meta.upcase.index('NIKKEI')
    return Fund.find_by_name('cac') if meta.upcase.index('CAC')
    return Fund.find_by_name('bse') if meta.upcase.index('BSE Sensex')
    return Fund.find_by_name('dubai') if meta.upcase.index('DUBAI')
    return Fund.find_by_name('cnx') if meta.index('CNX NIFTY')
    return Fund.find_by_name('ta') if meta.upcase.index('TA-25')

    return Fund.find_by_name('oil') if meta.upcase.index('CRUDE')
    return Fund.find_by_name('gold') if meta.upcase.index('GOLD')

    return Fund.find_by_name('morgan') if meta.index('Morgan Stanley')
    return Fund.find_by_name('coalindia') if meta.index('Coal India')
    return Fund.find_by_name('reliance') if meta.index('Reliance Industries')
    return Fund.find_by_name('tata') if meta.index('Tata Consultancy')
    return Fund.find_by_name('indiabank') if meta.index('State Bank Of India')
    return Fund.find_by_name('idfc') if meta.index('IDFC Ltd')
    return Fund.find_by_name('bharti') if meta.index('Bharti')

    fname = meta.split.last
    if fname.index('/') # валюты
      fund = Fund.find_by_full_name(fname)
    else
      fund = Fund.find_by_name(fname.downcase)
    end
    return fund if fund
    raise "No fund: #{meta}"
  end

  def open(date = nil)
    date = Date.today unless date
    if self.available_open_time
      Time.parse(self.available_open_time.strftime('%H:%M:%S'), date)
    else
      Time.parse(self.open_time.strftime('%H:%M:%S'), date)
    end
  end

  def close(date = nil)
    date = Date.today unless date
    if self.available_close_time
      Time.parse(self.available_close_time.strftime('%H:%M:%S'), date)
    else
      Time.parse(self.close_time.strftime('%H:%M:%S'), date)
    end
  end

  def open?(session)
    return false unless Event.open?(self, session) # выходной или праздник
    now = Time.now.strftime("%H%M%S%N")
    open = self.open_time.strftime("%H%M%S%N")
    close = self.close_time.strftime("%H%M%S%N")
    return now >= open && now <= close
  end


  def close?
    not open?
  end

  def next_business_day(date)
    skip_weekends(date, 1)
  end

  def previous_business_day(date)
    skip_weekends(date, -1)
  end

  def skip_weekends(date, inc)
    date += inc
    while (date.wday % 7 == 0) or (date.wday % 7 == 6) do
      date += inc
    end
    date
  end

  # возвращает текующую дату, если open? иначе последний open? день
  def business_date
    if open? # курс открыт
      Date.today
    else # последний рабочий день
      previous_business_day(Date.today)
    end
  end

  def valuta?
    self.category == 'valuta'
  end

  def light
    'circle.white.png'
  end


end

# __FILE__
# # текущий курс в зависимости от переданной даты и времени
# def rate(time=nil)
#   @print = true
#   puts "request time: #{time.to_sdt}" if time && @print
#   if time
#     # rtime = Time.now.to_ms
#     # all_ticks = ticks.where('ms >= ? and ms <= ?', (time-2).to_ms, time.to_ms)
#     # puts "Fund.tick.all[#{all_ticks.size}]: #{Time.now.to_ms - rtime} ms\n"
#     rtime = Time.now.to_ms
#     # выбираем тики за последние 10 секунд
#     list = Tick.where('fund_id =? AND ms >= ? AND ms <= ?', self.id, (time-10).to_ms, time.to_ms)
#     puts "Fund.rate.list[#{list.size}]: #{Time.now.to_ms - rtime} ms" if @print
#     unless list.empty? # если список не пуст
#       puts "Fund.rate.tick[#{list.last.time.to_sdt} #{list.last.rate}] #{Time.now.to_ms - rtime} ms" if @print
#       return list.last.rate # возвращаем значение последнего тика
#     else # читаем 5s бар
#       bar = Bar.where('frame_id = 5 AND fund_id = ? AND open_time > ? AND close_time <= ? ',
#                       self.id, time, time ).last
#       puts "Fund.rate.bar[#{bar.time.to_sdt} #{bar.close}] #{Time.now.to_ms - rtime} ms" if @print
#       return bar.close
#     end
#     rtime = Time.now.to_ms
#     tick = list.last
#     # tick = Tick.where('fund_id = ? and time >= ?', self.id, time).first
#     # tick = Tick.find_by_sql("fund_id = #{self.id} and time > #{time.to_s(:db)}")
#     puts "Fund.tick.last: #{Time.now.to_ms - rtime} ms" if @print
#   else
#     return ticks.last.rate
#   end
#   # puts "Fund.tick[#{tick.time.to_sdt}] #{tick.rate}" if @print
#   # tick.rate
# end
#
# # текущий курс в зависимости от переданной даты и времени
# def rate(time=nil)
#   puts "request time: #{time.to_sdt}" if time
#   rtime = Time.now.to_ms
#   if time
#     ttime = Time.now.to_ms
#     # tick = Tick.find_by_fund_id(self.id)
#     tick = ticks.where('time <= ?', time).limit(1).last
#     puts "Fund.tick[#{time.to_sdt}]: #{Time.now.to_ms - ttime} ms\n"
#     btime = Time.now.to_ms
#     # bar = Bar.where('fund_id = ? AND time <= ?', self.id, time).limit(1).last
#     bar = Bar.find_by_fund_id(self.id)
#     bar = bars.where('time <= ?', time).limit(1).last
#     puts "Fund.bar(#{bar.frame.name})[#{bar.time}]: #{Time.now.to_ms - btime} ms\n"
#   else
#     tick = ticks.last unless ticks.empty?
#     bar = bars.last unless bars.empty?
#     time = Time.now
#   end
#   return nil unless tick && bar
#   # определяем где наименьшее расстояние по времени
#   ms_tick = time.to_ms - tick.time.to_ms
#   ms_bar = time.to_ms - bar.close_time.to_ms
#   if ms_tick < ms_bar
#     tick.rate
#   else
#     bar.close
#   end
# end


# вычисление веса производной
# def der
#   # берем последние 6 значений тиков, чтобы вычислить 5 производных
#   ts = ticks.last(6)
#   der = []
#   # шагаем по всем тикам
#   1.upto(ts.size-1) do |i|
#     t1 = ts[i-1]
#     t2 = ts[i]
#     dx = (t2.time - t1.time) / 10.0 # коррекция по весу времени
#     dy = t2.rate - t1.rate
#     dd = (dy / dx).round(2)
#     der << dd
#   end
#   # Максимальное значение производной может доходить до 20.
#   # Очень резкое движение дают значение от 10
#   light = 0
#   res = []
#   weight = 1.0 # определяем изначальный вес
#   # проходим по производным в обратной последовательности
#   (der.size-1).downto(0) do |i|
#     d = der[i]
#     d = 10 if d > 10 # Примем 10 за максимум и обрежем все что сверху
#     d = d / 5.0 # нормализуем значения
#     res << d
#     light = d * weight # включаем свет
#     weight = weight * 0.7 # убавляем вес этой производной на каждом шагу
#   end
#   # light = light / 5 # усредняем свет
#   light = 1 if light > 1.0
#   light = -1 if light < -1.0
#   [light.round(2)] + [0] + der + [0]+ res.reverse
# end
# def light
#   # .light= image_tag('circle.coral.png')
#   # .light= image_tag('circle.orange.png')
#   #     .light= image_tag('circle.gold.png')
#   #     .light= image_tag('circle.yellow.png')
#   #     .light= image_tag('circle.lightgreenyellow.png')
#   #     .light= image_tag('circle.greenyellow.png')
#   #     .light= image_tag('circle.yellowgreen.png')
#   #     .light= image_tag('circle.green.png')
#   #     .light= image_tag('circle.white.png')
#   'circle.white.png'
# end

