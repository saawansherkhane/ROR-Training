require 'rails_helper'

RSpec.describe Customer, type: :model do

  before(:each)do
    @branch = Branch.create!(name: "kormangala Branch")
  end

  it "should not create a customer if name is not present" do
    expect {Customer.customer_create(name: nil, email: "karthik@gmail.com", phone: "43564656", branch_id: @branch.id)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not create a customer if email is incorrect" do
    cust = {name: "kra", email: "kra@.com", phone: "678768", branch_id: @branch.id, status: true}
    expect {Customer.customer_create(cust)}.to raise_error ActiveRecord::RecordInvalid
  end

  it "should not create a customer if phone number is blank" do
    cust = {name: "vaidi", email: "vaidi@kre.com", phone: nil, branch_id: @branch.id, status: true}
    expect {Customer.customer_create(cust)}.to raise_error ActiveRecord::RecordInvalid
  end

  it "should not create a customer if branch is blank" do
    cust = {name: "mouli", email: "mouli@kre.com", phone: "2342325", branch_id: nil, status: true}
    expect {Customer.customer_create(cust)}.to raise_error ActiveRecord::RecordInvalid
  end

  it "should not create a customer if name is already taken" do
    cust = Customer.create!(name: "saawan", email: "kar@kreatio.com", phone: "8963748", branch_id: @branch.id, status: true)

    cust1 = {name: cust.name, email: "kar@kreatio.com", phone: "8963748", branch_id: @branch.id, status: true}
    expect {Customer.customer_create(cust1)}.to raise_error ActiveRecord::RecordInvalid
  end

  it "should delete a customer" do
    cust_id = {id: "111"}
    expect {Customer.customer_delete(cust_id)}.to  raise_error ActiveRecord::RecordNotFound
  end

  it "should activate customer" do
    customer = Customer.customer_create(name: "testapp", email: "testapp@gmail.com", phone: "46564563", branch_id: @branch.id, status: nil)
    customer.activate()
    expect(customer.reload.status).to eq true
  end

  it "should deactivate customer" do
    customer = Customer.customer_create(name: "testapp1", email: "testapp1@gmail.com", phone: "46564563", branch_id: @branch.id, status: true)
    customer.deactivate()
    expect(customer.reload.status).to eq false
  end

  # it "Should check for status if customer is deactivate" do
  #   customer = Customer.customer_create(name: "saawan", email: "saawan@gmail.com", phone: "2342234", branch_id: @branch.id, status: nil)
  #   expect {Customer.deactivate(id: customer.id)}.to raise_error ActiveRecord::RecordInvalid
  #   expect(customer).to be
  #   expect(customer.reload.status).to eq false
  # end
  #
  # it "is not valid without a name" do
  #   branch1 = Branch.create(name: "hosur road")
  #   customer1 = Customer.new(name: nil, email: "vaidi@kreatio.com", phone: "678578", branch_id: branch1.id)
  #   expect(customer1).to_not be_valid
  # end


end
