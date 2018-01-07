class Account < ApplicationRecord
  belongs_to :customer
  has_many :account_transactions

  validates_presence_of :customer_id

  def self.create_customer(customer_attrs)
    error_flag = false
    customer = nil
     Customer.transaction do
      customer = Customer.create(name: customer_attrs[:name], email: customer_attrs[:email], phone: customer_attrs[:phone], branch_id: customer_attrs[:branch_id])
       unless customer
         error_flag=true
       end
     end
    return error_flag, customer
  end

  def self.update_customer(customer_attrs)
    error_flag = false
    customer = nil
     Customer.transaction do
      customer = Customer.find_by_id(customer_attrs[:id])
       customer.name = customer_attrs[:name]
       unless customer  && customer.update_attributes(customer_attrs)
        error_flag=true
       end
     end
    return error_flag,customer
  end

  def self.destroy_customer(customer_attrs)
    customer = Customer.find(customer_attrs[:id])
    customer.destroy!
  end

  def self.list_customer
    customer = Customer.all
    customer.count
  end

  def self.opening(account_attrs)
    error_flag = false
    customer = nil
    account = nil
    account_transaction = nil
     Customer.transaction do
      Account.transaction do
       AccountTransaction.transaction do
         customer = Customer.create(name: account_attrs[:name], email: account_attrs[:email], phone: account_attrs[:phone], branch_id: account_attrs[:branch_id])
         account = Account.create(customer_id: customer.id, opened_date: Time.now, balance: account_attrs[:balance], meta_name: 'Money deposit')
         account_transaction = AccountTransaction.create(account_id: account.id, amount: account.balance, description: "Money deposit to open a new account", from_id: account.id)
         unless customer  && account && account_transaction
           error_flag=true
         end
       end
      end
     end
    return error_flag, customer, account, account_transaction
  end


  def active_account()
    if self.status == [false, nil]
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, true)
  end

  def deactive_account()
    if self.status == [true, nil]
      raise ActiveRecord::RecordInvalid
    end
    update_attribute(:status, false)
  end

  def self.closing(account_attrs)
    error_flag = false
    customer = nil
    account = nil
    account_transaction = nil
     Customer.transaction do
      Account.transaction do
        AccountTransaction.transaction do
         customer = Customer.find(account_attrs[:id])
         account = Account.where(customer_id: customer.id).first
         account_transaction = AccountTransaction.where(account_id: account.id)
         customer.destroy!
         account.destroy!
         account_transaction.delete_all
         unless customer  && account && account_transaction
           error_flag=true
         end
        end
       end
     end
    return error_flag, customer, account, account_transaction
  end

  def self.deposit(acc_dep)
    error_flag = false
    account = nil
    account_transaction = nil
     Account.transaction do
      AccountTransaction.transaction do
        account = Account.find(acc_dep[:id])
        account_transaction = AccountTransaction.create(account_id: account.id, amount: acc_dep[:amount], description: "Money deposit", from_id: account.id)
        account.balance = account.balance + acc_dep[:amount]
        account.update_attribute("balance", account.balance)
         unless account  && account_transaction
          error_flag=true
         end
       end
     end
    return error_flag, account, account_transaction
  end

  def self.withdraw(acc_withdraw)
    error_flag = false
    account = nil
    account_transaction = nil
     Account.transaction do
       AccountTransaction.transaction do
        account = Account.find(acc_withdraw[:id])
        account_transaction = AccountTransaction.create(account_id: account.id, amount: acc_withdraw[:amount], description: "Money withdraw", from_id: account.id)
        account.balance = account.balance - acc_withdraw[:amount]
        account.update_attribute("balance", account.balance)
         unless account  && account_transaction
          error_flag=true
         end
       end
     end
   return error_flag, account,account_transaction
  end

  def self.transfer(acc_trans)
    error_flag = false
    account1, account2, account_transaction = nil
     Account.transaction do
       AccountTransaction.transaction do
        account1 = Account.find(acc_trans[:id1])
        account2 = Account.find(acc_trans[:id2])
        account_transaction = AccountTransaction.create(account_id: account1.id, amount: acc_trans[:amount], description: "Money transfer", from_id: account1.id, to_id: account2.id)
        account1.balance = account1.balance - acc_trans[:amount]
        account2.balance = account2.balance + acc_trans[:amount]
        account1.update_attribute("balance", account1.balance)
        account2.update_attribute("balance", account2.balance)
         unless account1  && account2 && account_transaction
          error_flag=true
         end
       end
     end
    return error_flag, account1, account2, account_transaction
  end

  # Example exception for customer
  def self.except_customer(customer_id)
    begin
      c = Customer.find_by!(id: customer_id)
    rescue Exception => e
      print "Exception for customer #{e}"
    end
    return c
  end

  # Example exception for account
  def self.except_account(account_id)
    begin
      a = Account.find_by!(id: account_id)
    rescue Exception => e
      print "Exception for account #{e}"
    end
    return a
  end

end
