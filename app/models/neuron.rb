class Neuron < ActiveRecord::Base
  NAMES = %w( out angle trend level sign )
  TYPES = %w( Neuron::Out Neuron::Angle Neuron::Trend Neuron::Level Neuron::Sign )
  default_scope { order(:position) }
  belongs_to :edge
  has_many :data
  has_many :sources, foreign_key: :recipient_id, class_name: :Nerve # ключ изменен для правильной агрегации
  has_many :recipients, foreign_key: :source_id, class_name: :Nerve # ключ изменен для правильной агрегации

  before_create


  def self.find_by_edge_type(edge,name)
    index = NAMES.index name
    type = TYPES[index]
    Neuron.find_by(edge: edge, type: type)
  end

  def to_s
    "Neuron[#{id}] #{name}, edge: #{edge.name}, sources: #{sources.size}, recipients: #{recipients.size}, data: #{data.size}, factor: #{factor}, position: #{position}"
  end

  def name
    self.type.after('::').downcase
  end

  def name=(name)
    index = NAMES.index name
    self.type = TYPES[index]
  end

  # # переопределение стандартного метода, для поиска по имени
  # def self.find_or_create_by(attributes, &block)
  #   if attributes[:name]
  #     index = NAMES.index attributes[:name]
  #     attributes.delete(:name)
  #     attributes[:type] = TYPES[index]
  #   end
  #   ActiveRecord::Base.find_or_create_by(attributes, &block)
  # end

  # возвращает ближайшее значение состояния нейрона для фонда и вермени
  # если время не передано, то последнее значение
  def value(fund_id,time=nil)
    if time
      d = data.where('fund_id = ? and time <= ?', fund_id, time).last
    else
      d = data.where(fund_id: fund_id).last
    end
    d.value if d
  end

  # отображает последнее значетие нейрона
  def title(fund_id)
    value(fund_id)
  end


  # внешний сигнал
  def pulse
    @print = crystal.print
    if !self.children.empty? # если есть дети
      self.level = significance # учитываем их заслуги
      save! # сохраняем эти заслуги
      level = self.level
    elsif self.class == Neuro::SignNeuron # если это знаковый нейрон [-1,0,1]
      level = self.level * 9 # то усиливаем сигнал до максимума
    else # иначе
      level = self.level # просто копируем сигнал из базы
    end
    print self if @print
    # Neuro::Pulse.store(impulse,self,level) # сохранение сигнала
    level
  end

  # заслуги детей
  def significance
    total_weight = 0.0 # значимость всех детей
    sum = 0.0
    self.children.reverse_each do |n| # проходим по всем детям в обратном порядке
      if n.weight != 0 # если нейрон имеет вес
        total_weight += n.weight # увеличиваем общую силу притяжения
        gravity = n.level * n.weight # сила притяжения нейрона на основе веса и уровня сигнала
        sum += gravity # # вычисляем общую сумму
      end
    end
    if total_weight != 0
      (sum / total_weight).round
    else
      10
    end
  end

  def crystal
    self.edge.crystal
  end

  # может быть переопределено в подклассе для коррекции результата
  # def response(sum, count)
  #   result = sum / count #
  #   result.round
  # end
  #
  # def color
  #   if self.level.nil? || self.level.abs > 9 # зашкалили
  #     COLORS[10] # сигнал об ошибке
  #   else
  #     COLORS[self.level.abs] # рабочий цвет от красного до зеленого 0 - красный
  #   end
  # end

  # def image_name
  #   "circle.#{self.color}.png"
  # end
  #

  def level_to_s
    if self.level.nil?
      '0'
    elsif self.level > 0
      " #{level} "
    elsif self.level < 0
      " - #{level.abs}"
    else
      '0'
    end
  end

end

# ПОДВАЛ
# def pulse(layer)
#   list = significant(layer) # список значимых нейронов
#   if list.empty? # если он пуст
#     0 # то никакого сигнала нет
#   else # иначе
#     result = list.inject(0.0) do |sum, n| # суммируем связи
#       link = Neuro::Link.where(:lower_id => n.id, :upper_id => self.id).first # находим связь между нейронами
#       # print "(#{link.weight}) "
#       # print n
#       sum + n.level * link.weight / 10.0 # вычисляем сумму на основе связи и уровня сигнала max = 9
#     end
#     response(result, list.size) # усредняем результат
#   end
# end
#
# # поиск только значимых связей
# def significant(layer)
#   layer.select do |n| # суммируем все связи
#     link = Neuro::Link.where(:lower_id => n.id, :upper_id => self.id).first # находим связь между нейронами
#     link.weight && link.weight != 0 # если связь имеет значение
#   end
# end
# # ищет нейрон по имени
# def get(name)
#   lows.detect do |n|
#     n.name.to_sym == name
#   end
# end
#
# # нижние нейроны
# def lows
#   # опускаемся на уровень вниз и собираем все нейроны из замкнутой цепочки
#   Neuron.to_a(self.low)
# end
#
# # цепочка нейронов собранная в массив
# def self.to_a(n)
#   if n.nil? # никого нет
#     []
#   elsif n.next.nil? || n.next == n.id # есть только один нейрон
#     [n]
#   elsif n.next == n.prev # есть только два нейрона
#     [n, n.next]
#   elsif n.next.next == n.prev # есть только три нейрона
#     [n.prev, n, n.next]
#   else # есть цепочка из нейнов больше трех
#     a = []
#     begin
#       a << n
#       n = n.next # проходим на следюущий элемент цепочки
#     end while n != a[0] # вываливаемся, когда цепочка замкнулась
#     a
#   end
# end

