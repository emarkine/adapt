# задачи для нейросети
namespace :neuro do

  # задачи для нейрона
  namespace :neuron do

    # установка калибровочного фактора умножения
    task :factor, [:name, :edge, :value] => :environment do |task, args|
      raise "Usage: rake #{task}[:name, :edge, :value]" unless args[:name] && args[:edge] && args[:value]
      set, edge = se(args)

    end

  end

  # задачи для нейроузла
  namespace :node do

    # выходной нейрон соединяется нервами со всеми другими
    task :init, [:name] => :environment do |task, args|
      raise "Usage: rake #{task}[:name]" unless args[:name]
      node = Node.find_by_name args[:name]
      raise 'No node: ' + args[:name] unless node
      puts node
      node.edges.each do |edge|
        puts edge
        nerves(node,edge)
      end
    end

    # добавление грани для узла
    task :add, [:node, :edge] => :environment do |task, args|
      raise "Usage: rake #{task}[:name]" unless args[:node] && args[:edge]
      node = Node.find_by_name args[:node]
      raise 'No node: ' + args[:node] unless node
      puts node
      edge = Edge.find_by_name args[:edge]
      raise 'No edge: ' + args[:edge] unless edge
      puts edge
    end
  end

  # задачи для грани
  namespace :edge do

    # вывод статистики за день
    task :stat, [:name, :fund, :frame, :date] => :environment do |task, args|
      raise "Usage: rake #{task}[:name, :fund, :frame, :date=today]" unless args[:name] && args[:fund] && args[:frame]
      edge, fund, frame = eff(args)
      time_begin, time_end = period(args)
      edge.neurons.each do |neuron|
        data = Datum.where('fund_id = ? and frame_id = ? and neuron_id = ? and time >= ? and time <= ?', fund.id, frame.id, neuron.id, time_begin, time_end)
        puts neuron
        result = {}
        (9).downto(-9) { |i| result[i] = 0 }
        data.each do |d|
          result[d.value] += 1
        end
        if neuron.name == 'sign'
          puts "+:\t#{result[1]}"
          puts "0:\t#{result[0]}"
          puts "-:\t#{result[-1]}"
        else
          result.each_key { |key| puts "#{key}:\t#{result[key]}" }
        end
      end
    end

    # neuro:edge:show[overlap]

    # создание стандартного набора нейронов
    task :create, [:name] => :environment do |task, args|
      raise "Usage: rake #{task}[:name]" unless args[:name]
      setting = Setting.find_by_name args[:name]
      raise 'No setting: ' + args[:name] unless setting
      puts setting
      edge = Edge.find_by_setting_id setting.id
      raise 'No edge for setting: ' + setting.name unless edge
      puts edge
      neurons(edge)
    end

    # выходной нейрон соединяется со всеми другими
    task :init, [:node, :edge, :value, :level] => :environment do |task, args|
      raise "Usage: rake #{task}[:name, :value=1, :level=0]" unless args[:name]
      edge = Edge.find_by_name args[:name]
      nerves(edge, args[:value], args[:level])
    end

    # удаление одного из нейронов и его нервов
    task :delete, [:edge,:type] => :environment do |task, args|
      raise "Usage: rake #{task}[:name]" unless args[:edge] && args[:type]
      edge = Edge.find_by_name args[:edge]
      raise 'No edge: ' + args[:edge] unless edge
      index = Neuron::NAMES.index args[:type]
      raise 'No neuron type: ' + args[:type] unless index
      type = Neuron::TYPES[index]
      neuron = Neuron.find_by(edge: edge, type: type)
      raise "No neuron type #{args[:type]} for edge " + args[:edge] unless neuron
      neuron.sources.destroy_all
      neuron.recipients.destroy_all
      neuron.destroy!
      puts "Neuron :#{args[:type]} deleted from '#{args[:edge]}'"
      puts edge
    end


    # соединение нервом выходного нейрона и одного из других нейронов грани
    task :nerve, [:name, :fund, :frame, :name, :value, :level] => :environment do |task, args|
      raise "Usage: rake #{task}[:name, :fund, :frame, :name, :value=0]" unless args[:name] && args[:fund] && args[:frame] && args[:name]
      set, edge, fund, frame = seff(args)
      out = Neuron.find_or_create_by(type: 'Neuron::Out', edge: edge, position: 0)
      puts(out)
      index = Neuron::NAMES.index args[:name]
      raise 'No neuron name: ' + args[:name] unless index
      type = Neuron::TYPES[index]
      neuron = Neuron.find_or_create_by(edge: edge, type: type)
      puts(neuron)
      nerve = Nerve.find_or_create_by(source: neuron, recipient: edge.out, fund: fund, frame: frame)
      # puts(nerve)
      # response = Response.find_or_create_by(nerve: nerve, fund: fund, frame: frame)
      if args[:value]
        nerve.value = args[:value]
        nerve.save!
      end
      if args[:level]
        nerve.level = args[:level]
        nerve.save!
      end
      puts nerve
      # nerve = Nerve.find_or_create_by(source: neuron, recipient: out)
      # puts(nerve)
      # # response = Response.find_or_create_by(nerve: nerve, fund: fund, frame: frame)
      # if args[:value]
      #   response.value = args[:value]
      #   response.save!
      # end
      # puts(response)
    end

  end

  # задачи для кристалла
  namespace :crystal do

    # создание кристалла с центральной осью
    task :create, [:name] => :environment do |task, args|
      raise "Usage: rake #{task}[:name]" unless args[:name]
      crystal = Crystal.find_or_create_by name: args[:name]
      raise 'No crystal: ' + args[:name] unless crystal
      Rake::Task['neuro:edge:create'].invoke args[:name]
      edge = Edge.find_by_name args[:name]
      structure = Structure.find_or_create_by crystal: crystal, edge: edge, position: 0
      puts structure
      puts crystal
    end

    # добавление грани в кристалл
    task :add, [:crystal, :edge] => :environment do |task, args|
      raise "Usage: rake #{task}[:crystal,:edge]" unless args[:crystal] && args[:edge]
      crystal = Crystal.find_by_name args[:crystal]
      raise 'No crystal: ' + args[:crystal] unless crystal
      edge = Edge.find_by_name args[:edge]
      raise 'No edge: ' + args[:edge] unless edge
      axis = crystal.axis
      raise 'No axis for crystal: ' + args[:name] unless axis
      puts axis
      structure = Structure.find_by crystal: crystal, edge: edge
      structure = Structure.create crystal: crystal, edge: edge, position: crystal.structures.size unless structure
      puts structure
      axis.neurons.each_with_index do |out, position| # проходим по всем нейронам
        neuron = Neuron.find_by edge: edge, position: position
        nerve = Nerve.find_or_create_by source: neuron, recipient: out
        puts nerve.to_s true
      end
      puts edge
      puts crystal
    end

    # инициализация или показ структуры  кристалла для конкретной среды и частоты
    task :init, [:name, :fund, :frame] => :environment do |task, args|
      raise "Usage: rake #{task}[:name, :fund, :frame]" unless args[:name] && args[:fund]
      crystal = Crystal.find_by_name args[:name]
      raise 'No crystal: ' + args[:name] unless crystal
      puts crystal
      axis = crystal.axis
      raise 'No axis for crystal: ' + args[:name] unless axis
      fund, frame = ff(args)
      axis.neurons.each_with_index do |out, position| # проходим по всем нейронам
        crystal.edges.each_with_index do |edge, index|
          next if index == 0
          neuron = Neuron.find_by edge: edge, position: position
          nerve = Nerve.find_or_create_by source: neuron, recipient: out
          response = Response.find_or_create_by nerve: nerve, fund: fund, frame: frame
          puts response
        end
      end
      crystal.edges.each_with_index do |edge, position|
        puts edge
        neurons(edge)
        nerves(edge, fund, frame) if fund
      end
    end

    # соединение нервом выходного нейрона кристалла и одного из нейронов другой грани
    task :nerve, [:name, :edge, :type, :fund, :frame, :value] => :environment do |task, args|
      raise "Usage: rake #{task}[:setting, :fund, :frame, :name, :value=0]" unless args[:name]  && args[:edge] && args[:type] && args[:fund] && args[:frame]
      raise "Usage: rake #{task}[:name, :fund, :frame]" unless args[:name] && args[:fund]
      crystal = Crystal.find_by_name args[:name]
      raise 'No crystal: ' + args[:name] unless crystal
      puts crystal
      axis = crystal.axis
      raise 'No axis for crystal: ' + args[:name] unless axis
      puts axis
      out = axis.out
      raise 'No out neuron for crystal: ' + args[:name] unless out
      puts out
      edge = Edge.find_by_name args[:edge]
      raise 'No edge: ' + args[:edge] unless edge
      puts edge
      index = Neuron::NAMES.index args[:type]
      raise 'No neuron type: ' + args[:type] unless index
      type = Neuron::TYPES[index]
      neuron = Neuron.find_by(edge: edge, type: type)
      raise "No neuron type #{args[:type]} for edge " + args[:edge] unless neuron
      fund, frame = ff(args)
      puts neuron
      nerve = Nerve.find_or_create_by(source: neuron, recipient: out)
      puts nerve
      response = Response.find_or_create_by(nerve: nerve, fund: fund, frame: frame)
      if args[:value]
        response.value = args[:value]
        response.save!
      end
      puts response
    end

    # создание кристалла и его граней на основе индикатора
    task :indicator, [:name, :fund, :frame] => :environment do |task, args|
      raise "Usage: rake #{task}[:indicator, :fund, :frame]" unless args[:name]
      indicator = Indicator.find_by_name args[:name]
      raise 'No indicator: ' + args[:name] unless indicator
      puts indicator
      crystal = Crystal.find_or_create_by indicator: indicator
      puts crystal
      fund, frame = ff(args)
      indicator.settings.each_with_index do |setting, position|
        edge = Edge.find_or_create_by(crystal: crystal, setting: setting, position: position)
        puts edge
        neurons(edge)
        nerves(edge, fund, frame)
      end
    end

    # соединение нейронов оси с остальными гранями с помощью нервов
    task :connect, [:name, :fund, :frame] => :environment do |task, args|
      axis = crystal.axis
      raise 'No axis for crystal: ' + args[:name] unless axis
      puts axis
      axis.neurons.each_with_index do |out, position| # проходим по всем нейронам
        crystal.edges.each_with_index do |edge, index|
          next if index == 0
          neuron = Neuron.find_by edge: edge, position: position
          nerve = Nerve.find_or_create_by(source: neuron, recipient: out)
          # puts(nerve)
          response = Response.find_or_create_by(nerve: nerve, fund: fund, frame: frame)
          puts(response)
        end
      end
    end

  end

  private

  # вывод или генерация стандартоного набора нейронов
  def neurons(edge)
    0.upto(Neuron::TYPES.size-1) do |position|
      neuron = Neuron.find_or_create_by(type: Neuron::TYPES[position], edge: edge, position: position)
      puts(neuron)
    end
  end

  # вывод или генерация нервов связанных с выходным нероном
  def nerves(node, edge, value=nil, level=nil)
    puts(edge.out)
    edge.neurons.each_with_index do |neuron, index|
      next if index == 0
      # puts(neuron)
      nerve = Nerve.find_or_create_by(node: node, source: neuron, recipient: edge.out)
      # puts(nerve)
      # response = Response.find_or_create_by(nerve: nerve, fund: fund, frame: frame)
      if value
        nerve.value = value
        nerve.save!
      end
      if level
        nerve.level = level
        nerve.save!
      end
      if nerve.id.nil?
        nerve.save!
      end
      puts nerve
    end
  end

  # соединение нервом нейрона одной грани с нейроном другой
  task :nerve, [:source, :source_type, :recipient, :recipient_type, :value, :level] => :environment do |task, args|
    raise "Usage: rake #{task}[:source, :source_type, :recipient, :recipient_type, :value=1, :level=0]" unless args[:source] && args[:source_type] && args[:recipient] && args[:recipient_type]
    source_edge = Edge.find_by_name args[:source]
    puts source_edge
    recipient_edge = Edge.find_by_name args[:recipient]
    puts recipient_edge
    source_neuron = Neuron.find_by_edge_type(source_edge,args[:source_type])
    puts source_neuron
    recipient_neuron = Neuron.find_by_edge_type(recipient_edge,args[:recipient_type])
    puts recipient_neuron
    nerve = Nerve.find_or_create_by(source: source_neuron, recipient: recipient_neuron)
    if args[:value]
      nerve.value = args[:value]
      nerve.save!
    end
    if args[:level]
      nerve.level = args[:level]
      nerve.save!
    end
    puts nerve
  end


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

  # инициализация периода по дате
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
