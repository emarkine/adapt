class ServicesController < ApplicationController
  # skip_before_action :require_login
  before_action :set_service

  def index
    @services = Service.all
    # @services.collect! { |service| service if service.setting.name != 'history' }.compact! unless session[:show_history] # убираем из списка все history сервисы
    # @services.collect! { |service| service if service.setting && service.setting.name != 'history' }.compact! unless session[:show_history] # убираем из списка все history сервисы
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


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id]) unless params[:id].blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:name, :setting_id, :fund_id, :frame_id, :position, :trigger_id, :ngroup, :host_id, :active, :single, :action, :refresh)
  end

end
