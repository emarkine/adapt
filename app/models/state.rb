class State < ApplicationRecord
  default_scope { order(:ms) }
  belongs_to :service

  def to_s
    "State[#{id}] #{name}, service: #{service.name}, #{time}"
  end

  def time
    Time.at(ms/1000)
  end

end
