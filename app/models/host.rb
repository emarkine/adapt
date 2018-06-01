class Host < ActiveRecord::Base
  has_many :services

  def <=>(other)
    self.id <=> other.id
  end


end
