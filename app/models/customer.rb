class Customer < ApplicationRecord
  has_one :account
  belongs_to :branch
  validates :name, presence: true
  validates :name, uniqueness: {message: "already taken" }
  validates :email, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "is not valid"
  validates :branch_id, presence: true
  validates :phone, presence: true

  def self.customer_create(cust_attrs)
     Customer.create!(name: cust_attrs[:name], email: cust_attrs[:email], phone: cust_attrs[:phone], branch_id: cust_attrs[:branch_id])
  end

  def self.customer_delete(cust_attrs)
     cust = Customer.find(cust_attrs[:id])
     cust.destroy!
  end

  # def self.activate(cust_attrs)
  #   cust = Customer.where(id: cust_attrs[:id], status: [false, nil]).first
  #   cust_attrs[:status] = true
  #   cust.update_attributes(cust_attrs)
  # end
  #
  # def self.deactivate(cust_attrs)
  #   cust = Customer.where(id: cust_attrs[:id], status: [true, nil]).first
  #   cust_attrs[:status] = false
  #   cust.update_attributes(cust_attrs)
  # end

  def activate()
    if self.status == [false, nil]
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, true)
  end

  def deactivate()
    if self.status == [true, nil]
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, false)
  end

end
