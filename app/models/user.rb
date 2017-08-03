class User < ApplicationRecord
  authenticates_with_sorcery!
  belongs_to :currency
  # belongs_to :country
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, email: true, presence: true, uniqueness: true
  validates :name, presence: true
  validates :currency_id, presence: true
  validates :balsance, presence: true
end
