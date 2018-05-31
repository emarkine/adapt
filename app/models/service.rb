class Service < ActiveRecord::Base
  default_scope { order(:updated_at) }
  belongs_to :setting
  belongs_to :fund
  belongs_to :frame
  belongs_to :host
  has_many :states

  # иехрархические связи между сервисами для обновления
  belongs_to :trigger, class_name: :Service, foreign_key: :trigger_id
  has_many :updatable, class_name: :Service, foreign_key: :trigger_id

  validates :name, :setting_id, :fund_id, :frame_id, :presence => true

  # after_save :update_statuses

  def self.list
    Service.where.not(status: nil)
  end

  def to_s
    s = "Service[#{name ? name : id}]: #{setting} #{fund} #{frame}"
    # s += ", status: #{status}"
    # s += ", #{Time.now.to_ms - @time} ms" if @time
    s
  end

  # отображаемое имя, если name явно не задано, то выводим id
  def sname
    n = read_attribute(:name)
    n.blank? ? id : n
  end

  def state
    states.last.name unless states.empty?
  end


  def group
    self.ngroup
  end

  def self.exist?(setting, fund, frame)
    Service.where(setting: setting, fund: fund, frame: frame).first
  end

  def start
    @time = Time.now.to_ms
    if service.state == SATE_OK
      Service.create(params)
    elsif !srv.running?
      Command.start(srv, params)
    end
    puts srv if @print
    srv
  end

  def run(date=nil)
    case setting.name
      when 'tick'
        cmd = "bin/tick -fund #{fund.name}"
      when 'history'
        if date
          cmd = "bin/history -fund #{fund.name} -frame #{frame.name} -date #{date}"
        else
          cmd = "bin/history -fund #{fund.name} -frame #{frame.name}"
        end
    end
    system(cmd) if cmd
  end

  def stop

  end


  def self.create(params)

  end

  def self.get(params)
    Service.where(:name => params[:name], :fund_id => params[:fund], :frame_id => params[:frame],
                  :indicator_id => params[:indicator], :indicator_setting_id => params[:setting]).first
    # srv = Service.create!(:name => params[:name], :fund_id => params[:fund],
    #                       :frame_id => params[:frame], :status => 'created') unless cmd
    # srv
  end

  def self.start_last_bar
    params = {}

  end

  def running?
    self.status == 'running'
  end

  def accepted?
    self.status == 'accepted'
  end

  # def status
  #   self.states.empty? ? '' : self.states.last.message
  # end

  # def update_statuses
  #   Status.update_statuses(self)
  #   puts "#{statuses.size} statuses"
  # end

end
