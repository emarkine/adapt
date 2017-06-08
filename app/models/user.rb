class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :email, email: true, presence: true, uniqueness: true

end
