class User < ApplicationRecord
  # User.connection
  authenticates_with_sorcery!
  belongs_to :currency
  belongs_to :country
  validates :email, email: true, presence: true, uniqueness: true
  validates :name, presence: true
  validates :country_id, presence: true
  validates :currency_id, presence: true
  validates :password, length: { minimum: 5 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def self.test
    User.find_by_name 'test'
  end

  def self.admin
    User.find_by_name 'admin'
  end

end
