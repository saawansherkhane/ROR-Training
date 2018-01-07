require "rails_helper"

RSpec.describe Account, :type => :model do

  before(:each)do
    @branch = Branch.create!(name: "Hebbal Branch")
  end

  # it "validates uniqueness of name" do
  #    FactoryGirl.build(:customer,name:"test").should_not be_valid
  # end

  it "should create an account" do
    cus = Customer.create!(name: "sree1", email: "sree1@kre.com", phone: "546543634", branch_id: @branch.id)
    account = Account.create!(balance: 100.0, customer_id: cus.id)
    ac = Account.find(account.id)
    expect(ac).to be
    expect(ac.id).to eq account.id
    expect(ac.balance).to eq 100.0
  end

  it "should activate account" do
    error_flag, customer, account, account_transaction = Account.opening(name: "atul", email: "atul@kre.com", phone: "76897897", branch_id: @branch.id, balance: 5000.0)
    account.active_account()
    expect(account.reload.status).to eq true
  end

  it "should deactivate account" do
    error_flag, customer, account, account_transaction = Account.opening(name: "chandra", email: "chandra@gmail.com", phone: "5465576", branch_id: @branch.id, balance: 7000.0)
    account.deactive_account()
    expect(account.reload.status).to eq false
  end

  it "should create customer" do
    customer_attrs = {name: "sree1", email: "sree1@kre.com", phone: "546543634", branch_id: @branch.id}
    error_flag, customer = Account.create_customer(customer_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("sree1")
  end

  it "should update customer" do
    customer_attrs = {name: "sree1", email: "sree1@kre.com", phone: "546543634", branch_id: @branch.id}
    error_flag, customer = Account.create_customer(customer_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("sree1")

    customer = Customer.find_by_name("sree1")
    update_customer_attrs = {name: "sree", email: "sree@kre.com", phone: "929292921", id: customer.id}
    error_flag, customer = Account.update_customer(update_customer_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("sree")
  end

  it "should open an account for the customer" do
    account_attrs = {name: "sree1", email: "sree1@kre.com", phone: "546543634", branch_id: @branch.id, balance: 9000.0}
    error_flag, customer, account, account_transaction = Account.opening(account_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("sree1")
    expect(account.reload.balance).to eq(9000.0)
    expect(account_transaction.reload.amount).to eq(9000.0)
  end

  it "should close an account for the customer" do
    account_attrs = {name: "sree1", email: "sree1@kre.com", phone: "546543634", branch_id: @branch.id, balance: 9000.0}
    error_flag, customer, account, account_transaction = Account.opening(account_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("sree1")
    expect(account.reload.balance).to eq(9000.0)
    expect(account_transaction.reload.amount).to eq(9000.0)

    customer = Customer.find_by_name("sree1")
    update_customer_attrs = {id: customer.id}
    error_flag, customer, account, account_transaction = Account.closing(update_customer_attrs)
    expect(error_flag).to eq(false)
    expect { customer.destroy! }.to change { Customer.count }.by(0)
    expect { account.destroy! }.to change { Account.count }.by(0)
    expect { account_transaction.delete_all }.to change { AccountTransaction.count }.by(0)
  end

  it "should deposit money to an account for the customer" do
    account_attrs = {name: "navin", email: "navin@kre.com", phone: "546543634", branch_id: @branch.id, balance: 9000.0}
    error_flag, customer, account, account_transaction = Account.opening(account_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("navin")
    expect(account.reload.balance).to eq(9000.0)
    expect(account_transaction.reload.amount).to eq(9000.0)

    acc_dep = {id: account.id, amount: 5000.0}
    error_flag, account1, account_transaction1 = Account.deposit(acc_dep)
    expect(error_flag).to eq(false)
    expect(account_transaction1.persisted?).to eq(true)
    expect(account1.reload.balance).to eq(14000.0)
    expect(account_transaction1.reload.amount).to eq(5000.0)
  end

  it "should withdraw money from the account for the customer" do
    account_attrs = {name: "navin", email: "navin@kre.com", phone: "546543634", branch_id: @branch.id, balance: 9000.0}
    error_flag, customer, account, account_transaction = Account.opening(account_attrs)
    expect(error_flag).to eq(false)
    expect(customer.persisted?).to eq(true)
    expect(customer.reload.name).to eq("navin")
    expect(account.reload.balance).to eq(9000.0)
    expect(account_transaction.reload.amount).to eq(9000.0)

    acc_withdraw = {id: account.id, amount: 5000.0}
    error_flag, account1, account_transaction1 = Account.withdraw(acc_withdraw)
    expect(error_flag).to eq(false)
    expect(account_transaction1.persisted?).to eq(true)
    expect(account1.reload.balance).to eq(4000.0)
    expect(account_transaction1.reload.amount).to eq(5000.0)
  end

  it "should transfer money from the account for the customer" do
    account_attrs1 = {name: "bharat", email: "bharat@kre.com", phone: "67876765", branch_id: @branch.id, balance: 12000.0}
    error_flag, customer1, account1, account_transaction1 = Account.opening(account_attrs1)
    expect(error_flag).to eq(false)
    expect(customer1.persisted?).to eq(true)
    expect(customer1.reload.name).to eq("bharat")
    expect(account1.reload.balance).to eq(12000.0)
    expect(account_transaction1.reload.amount).to eq(12000.0)

    account_attrs2 = {name: "venky", email: "venky@kre.com", phone: "56754567", branch_id: @branch.id, balance: 9000.0}
    error_flag, customer2, account2, account_transaction2 = Account.opening(account_attrs2)
    expect(error_flag).to eq(false)
    expect(customer2.persisted?).to eq(true)
    expect(customer2.reload.name).to eq("venky")
    expect(account2.reload.balance).to eq(9000.0)
    expect(account_transaction2.reload.amount).to eq(9000.0)

    acc_trans = {id1: account1.id, id2: account2.id, amount: 5000.0}
    error_flag, account1, account2, account_transaction = Account.transfer(acc_trans)
    expect(error_flag).to eq(false)
    expect(account_transaction.persisted?).to eq(true)
    expect(account1.reload.balance).to eq(7000.0)
    expect(account2.reload.balance).to eq(14000.0)
    expect(account_transaction.reload.amount).to eq(5000.0)
  end


end