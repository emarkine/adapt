class ServicesController < ApplicationController

  # skip_before_action :require_login
  before_action :set_service

  def index
    if session[:show_all]
      @services = Service.order(updated_at: :desc)
    else
      @services = Service.where.not(status: nil).order(updated_at: :desc)
    end
  end

  def sort
    name = params[:field]
    if session[:sort] == name #change sort direction
      if session[:sort_direction] == 'asc'
        session[:sort_direction] = 'desc'
      else
        session[:sort_direction] = 'asc'
      end
    else # create new sort direction
      session[:sort] = name
      session[:sort_direction] = 'asc'
    end
    dir = session[:sort_direction].to_sym
    if Service.reflections.keys.index(name)
      if session[:show_all]
        @services = Service.order(updated_at: :desc)
      else
        @services = Service.where.not(status: nil).order(updated_at: :desc)
      end
      if name == 'trigger'
        if dir == :asc
          @services = @services.to_a.sort do |one, two|
            a = one.send(session[:sort])
            b = two.send(session[:sort])
            (a and b) ? a <=> b : (a ? -1 : 1)
          end
        else
          @services = @services.sort do |one, two|
            a = one.send(session[:sort])
            b = two.send(session[:sort])
            (b and a) ? b <=> a : (b ? -1 : 1)
          end
        end
      else
        if dir == :asc
          @services = @services.to_a.sort_by(&name.to_sym)
        else
          @services = @services.to_a.sort_by(&name.to_sym).reverse!
        end
      end

      # @services = Service.includes(name.to_sym).order("#{name}.name DESC")
      # @services = Service.order(name.to_sym => dir)
    else
      if session[:show_all]
        @services = Service.order(name.to_sym => dir)
      else
        @services = Service.where.not(status: nil).order(name.to_sym => dir)
      end
    end

    render action: :index
  end

  def show
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      flash[:notice] = t(:message_create, :model => @service.name)
      redirect_to @service
    else
      render action: :new
    end
  end

  def update
    if @service.update_attributes(service_params)
      flash[:notice] = t(:message_update, :model => @service.name)
      redirect_to @service
    else
      render action: :edit
    end
  end

  def destroy
    @service.destroy
    flash[:notice] = t(:message_destroy, :model => @service.name)
    redirect_to action: :index
  end

  def group
    @services = Service.where(ngroup: params[:name])
    render action: :index
  end

  def frame
    @frame = Frame.find_by_name params[:name]
    @services = Service.where(frame: @frame)
    render action: :index
  end

  def host
    @host = Host.find_by_name params[:name]
    @services = Service.where(host: @host)
    render action: :index
  end

  def status
    if @service.status == 'started'
      @service.action = 'stop'
    elsif @service.status == 'stopped'
      @service.action = 'start'
    end
    @service.save!
    redirect_to action: :index
  end

  def show_history
    if session[:show_history]
      session[:show_history] = false
    else
      session[:show_history] = true
    end
    redirect_to action: :index
    # render :json => session[:show_history]
  end

  def show_all
    session[:show_all] = true
    redirect_to action: :index
  end

  def hide_all
    session[:show_all] = false
    redirect_to action: :index
  end

  private
  def set_service
    @service = Service.find(params[:id]) unless params[:id].blank?
  end

  def service_params
    params.require(:service).permit(:name, :setting_id, :fund_id, :frame_id, :position, :trigger_id, :ngroup, :host_id, :active, :single, :action, :refresh, :status)
  end

end
