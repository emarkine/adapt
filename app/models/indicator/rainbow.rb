# http://www.theignatpost.ru/magazine/index.php?mlid=1198
# http://berg.com.ua/indicators-overlays/stdev/
class Indicator::Rainbow < Indicator::MovingAverage

  def to_s
    s = "Indicator[#{id}]: #{name}"
    s += ", bars: #{@bars.size}" if @bars
    s += ", points: #{@points.size }" if @points
    s += ", #{Time.now.to_ms - @time} ms" if @time
    s
  end

  def init(graph)
    @time = Time.now.to_ms
    super(graph)
    # @print = true
    puts "#{self}" if @print
  end

  def calc_sign_future(one, two, three)
    if one > 0 && two > 0 && three > 0
      +1
    elsif one < 0 && two < 0 && three < 0
      -1
    else
      0
    end
  end

  def calc_sign_now(one, two, three)
    if one > two && one > three && two > three
      +1
    elsif one < two && one < three && two < three
      -1
    else
      0
    end
  end

  def calc_level(one, two, three)
    all_level = one + two + three
    level = (all_level.to_f / 2.5).to_i
    level = 9 if level > 9
    level = -9 if level < -9
    level
  end

  def calc_turn_(sign, one)
    if sign > 0 && one < 0
      +9
    elsif sign < 0 && one > 0
      -9
    else
      0
    end
  end

  def calc_turn(sign, rate, one, two, three)
    # if one < two && one < three && two < three # нормальная ситуация
    if sign > 0
      if rate < three
        +9
      elsif rate == three
        +8
      elsif rate < two
        +7
      elsif rate == two
        +6
      elsif rate < one
        +5
      elsif rate == one
        +4
      elsif (one - rate) > (two-one) # мы довольно близко к первой линии
        +3
      elsif (one - rate) > (three-one) # мы в отдалении от первой линии
        +2
      else
        0
      end
    elsif sign < 0
      if rate > three
        -9
      elsif rate == three
        -8
      elsif rate > two
        -7
      elsif rate == two
        -6
      elsif rate > one
        -5
      elsif rate == one
        -4
      elsif (one - rate) < (two-one) # мы довольно близко к первой линии
        -3
      elsif (one - rate) < (three-one) # мы в отдалении от первой линии
        -2
      else
        0
      end
    else # линии переплелись
      0
    end
  end


  # Индикатор получил сигнал от нейросети
  def pulse(impulse)
    points_one = Point.where(:indicator_id => self.id, :fund_id => @fund.id,
                                        :frame_id => @frame.id, :name => 'rainbow_one').last(4)
    points_two = Point.where(:indicator_id => self.id, :fund_id => @fund.id,
                                        :frame_id => @frame.id, :name => 'rainbow_two').last(4)
    points_three = Point.where(:indicator_id => self.id, :fund_id => @fund.id,
                                          :frame_id => @frame.id, :name => 'rainbow_three').last(4)
    one = points_one.last.value
    two = points_two.last.value
    three = points_three.last.value

    level_one, sign_one = level_sign(points_one)
    level_two, sign_two = level_sign(points_two)
    level_three, sign_three = level_sign(points_three)
    # sign = calc_sign_now(one, two, three)
    sign = calc_sign_future(sign_one, sign_two, sign_three)
    level = calc_level(level_one, level_two, level_three)
    turn = calc_turn(sign, @rate, one, two, three)
    # future = calc_sign_future(sign_one, sign_two, sign_three)
    puts "sign: #{sign}" if @print
    puts "level: #{level}" if @print
    puts "turn: #{turn}" if @print
    # puts "future: #{future}" if @print
    assign('sign_rainbow', sign)
    assign('level_rainbow', level)
    assign('turn_rainbow', turn)
    # assign('future_rainbow', future)
  end

end

