class User < ApplicationRecord
  authenticates_with_sorcery!
  belongs_to :currency
  belongs_to :country
  validates :email, email: true, presence: true, uniqueness: true
  validates :first_name, presence: true
  # validates :currency_id, presence: true
  # validates :balance, presence: true
  validates :password, length: { minimum: 5 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def name=(s)
    s.strip!
    self.first_name = s.split[0]
    self.last_name = s.last(s.size - self.first_name.size).strip
  end

end
