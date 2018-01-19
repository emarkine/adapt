# утилиты для задач rake

class Unit

# читаем фонд и фрейм, если нет то nil
  def self.ff(args)
    if args[:fund]
      fund = Fund.find_by_name args[:fund]
      puts fund
      # fund = Fund.find_by_name 'gold'
    end
    # raise 'No fund: ' + args[:fund] unless fund
    if args[:frame]
      frame = Frame.find_by_name args[:frame]
      puts frame
      # else
      # frame = Frame.find_by_name '1m'
    end
    # raise 'No frame: ' + args[:frame] unless frame
    [fund, frame]
  end

# читаем установку и грань, если нет, то вываливаемся
  def self.se(args)
    set = Setting.find_by_name args[:name]
    raise 'No set: ' + args[:name] unless set
    puts set
    edge = Edge.find_by_setting_id set.id
    raise 'No edge for setting: ' + set.name unless edge
    puts edge
    [set, edge]
  end

# читаем грань, фонд и фрейм
  def self.eff(args)
    set, edge = se(args)
    fund, frame = ff(args)
    [edge, fund, frame]
  end

# инициализация пероиодна по дате
  def self.period(args)
    if args[:date]
      date = Date.parse(args[:date])
      time_begin = Time.parse("00:00:01 #{date}")
      time_end = Time.parse("23:59:59 #{date}")
    else
      date = Date.parse(Time.now.to_s)
      time_begin = Time.parse("00:00 #{date}")
      time_end = Time.parse("#{Time.now.strftime('%T')} #{date}")
    end
    puts "Period: #{time_begin.strftime('%T')}-#{time_end.strftime('%T')}.#{date.strftime('%F')}"
    [time_begin, time_end]
  end

end

