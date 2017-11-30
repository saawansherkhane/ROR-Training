class Customer < ApplicationRecord
  has_one :account
  validates :name, uniqueness: {message: "Name already taken" }
  validates :email, presence: true, length: { maximum: 255 }
end
