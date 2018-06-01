class Setting < ActiveRecord::Base
  default_scope { order(:position) }
  belongs_to :indicator
  has_one :edge
  has_many :points
  has_many :services

  validates :name, :presence => true, :uniqueness => true

  # создание хеша с именами для отображения
  def self.session
    list = {}
    Setting.all.each do |s|
      list[s.name] = false
    end
    list
  end

  def self.list(indicator_id)
    if indicator_id.nil?
      Setting.all
    else
      indicator = Indicator.find indicator_id
      indicator.settings
    end
  end

  def to_s
    s = "Setting[#{name}]"
    s += " indicator: #{indicator.name}"
    s += ", period: #{period}" if period
    s += ", method: #{method}" if method
    s
  end

  # Последняя точка
  def point
    points.last
  end

  def <=>(other)
    self.name <=> other.name
  end

end
