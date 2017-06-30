class Country < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  def self.list
    list = Country.all.collect {|a| [ a.name, a.id ] }
    list.insert([0, Country.current])
    list
  end

  def self.local
    Country.find_by_code 'NL'
  end

  def self.current
    [local.name, local.id]
  end

end
