class State < ApplicationRecord
  default_scope { order(:time) }
  belongs_to :service
end
