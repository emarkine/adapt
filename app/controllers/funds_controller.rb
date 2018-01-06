class FundsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  # include ActionController::Live
  #respond_to :html, :xml, :json
  before_action do
    @init_time = Time.now.to_ms
    @print = true
    unless session[:indicator] # признак того, что мы запустились впервые
      session[:indicator] ||= {} # резервируем сессию для индикаторов, если ее нет
      session['bars'] = true # включаем отображение баров
      # session['deals'] = true # отображение сделок
    end
    @fund = Fund.find params[:id] unless params[:id].blank?
    if @fund
      session[:fund] = @fund.id
      @graph = Graph.init(@fund, session)
      if session[:frame]
        @frame = Frame.find session[:frame]
      else
        @frame = Frame.find_by_name '1m'
        session[:frame] = @frame.id
      end
      if session[:broker]
        @broker = Broker.find session[:broker]
      else
        @broker = Broker.find_by_name 'Test'
        session[:broker] = @broker.id
      end
      if session[:history]
        @history = session[:history]
      else
        @history = History.new
        @history.period_one_day(Date.today)
        session[:history] = @history
      end
      if session[:deal]
        @deal = Deal.load(session[:deal])
        # puts @deal
      else
        @deal = Deal.init(session, @fund, @broker)
      end
      if @fund != @deal.fund # поменялся фонд
        @deal.fund = @fund
        @deal.apply
        Deal.store(@deal, session[:deal])
      end
      if @broker != @deal.broker # поменялся брокер
        @deal.set(@broker)
        @deal.apply
        Deal.store(@deal, session[:deal])
      end
      # puts "fund[#{@fund.name}].before_filter: #{Time.now.to_ms - @init_time} ms\n" if @print
    end
    # unless session[:deal]
    #   @deal = Deal.create!( :fund => @fund, :broker => @broker, :user => @user,
    #                         :robot => @robot, :invest => @broker.invest)
    #   session[:deal] = @deal.id
    # else
    #   @deal = Deal.find session[:deal]
    # end
  end

  def index
    @funds = Fund.all
  end

  def new
    @fund = Fund.new
  end

  def show
    session[:time] = nil
  end


  def edit
    @fund.store_name = @fund.name
    @title = "#{Fund.model_name.human}: #{@fund.name}"
  end

  def create
    @fund = Fund.new(params[:fund])
    if @fund.save
      flash[:notice] = t(:message_create, :model => @fund.name)
      redirect_to @fund
    else
      render action: :new
    end
  end

  def update
    if @fund.update_attributes(params[:fund])
      flash[:notice] = t(:message_update, :model => @fund.name)
      redirect_to @fund
    else
      @fund.store_name = @fund.name
      render action: :edit
    end
  end

  def destroy
    @fund.destroy
    flash[:notice] = t(:message_destroy, :model => @fund.name)
    redirect_to action: :index
  end

  def file
    @fund = Fund.find(params[:id])
    send_file "#{@fund.path}/#{params[:filename]}"
  end

  def delete
    @fund = Fund.find(params[:id])
    File.delete "#{@fund.path}/#{params[:filename]}"
    redirect_to @fund
  end

  def rate
    # time = Time.now.to_ms
    render :json => "\"#{fund_rate_value(@rate, @fund)}\""
    # puts "rate: #{Time.now.to_ms - time}"
  end

  # отрисовка главного графика
  def draw
    @print = false
    @print_ind = false
    unless @graph.error?
      if session[:robot]
        @robot = Robot::Robot.find session[:robot]
        # todo тормозим сильно сдесь
        # @robot.draw(@graph)
      end
      @graph.draw_rate_grid
      @graph.draw_time_grid
      @graph.draw_bars if session['bars']
      @graph.draw_ticks if session['ticks']
      Deal.draw(@graph, session) if session['deals']
      @graph.rate_label
      if session[:indicator]
        session[:indicator].each_key do |name|
          if session[:indicator][name]
            indicator = Indicator.find_by_name name
            if indicator # && !indicator.canvas?
              time = Time.now.to_ms
              indicator.init(@graph)
              puts "indicator[#{indicator.name}].init: #{Time.now.to_ms - time} ms" if @print_ind
              time = Time.now.to_ms
              indicator.draw
              puts "indicator[#{indicator.name}].draw: #{Time.now.to_ms - time} ms" if @print_ind
            end
          end
        end
      end
    end
    render :json => @graph.list.collect { |item| item.to_json }
    puts "#{Time.now.to_stime} fund[#{@fund.name}].draw: #{Time.now.to_ms - @init_time} ms\n" if @print
  end

  def strategy
    @strategy = Strategy.find(params[:strategy_id])
    session[:strategy] = @strategy.id
    @deal.strategy = @strategy
    Deal.store(@deal, session[:deal])
    redirect_to @fund
  end

  # включить / выключить фонды для наблюдения
  def watch
    @fund.watch = !@fund.watch
    @fund.save!
    redirect_to action: :index
  end

  def frame
    @frame = Frame.find_by_name params[:frame]
    session[:frame] = @frame.id
    redirect_to @fund
    # render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  # вызываем при клике на тулбар
  def toolbar
    name = params[:name]
    if %w( histories ticks bars deals ).include?(name)
      session[name] = !session[name]
      # render :nothing => true, :status => 200, :content_type => 'text/html'
    else # обработка индикаторов
      @indicator = Indicator.find_by_name name # находим индикатор по имени
      session[:indicator][name] = !session[:indicator][name] if @indicator # переключаем его
      # session[:indicator] = Indicator.sort(session[:indicator]) # производим правильную сортировку
      # puts @indicator
      # render :partial => 'indicators/view'
    end
    # redirect_to :action => :show
    redirect_to @fund
  end

  # def select_date
  #   # @fund.selected_date = params[:date]
  #   date = Date.parse("#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}")
  #   session[:date] = date
  #   # @fund.selected_date = date
  #   # @fund.save!
  #   redirect_to @fund
  # end

  # прокрутка баров
  def scroll
    session[:scroll] = (100 - params[:shift].to_i) * session[:frame] # сдвиг в секундах
    redirect_to @fund
    # render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def change_refresh
    session[:refresh] = params[:refresh]
    # render :partial => 'refresh'
    # render :nothing => true, :status => 200, :content_type => 'text/html'
    redirect_to @fund
  end

end


# Подвал
#
