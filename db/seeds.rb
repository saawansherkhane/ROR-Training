# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

customer = Customer.first
Account.create!(customer_id: customer.id, opened_date: Time.now, balance: 1500.0, meta_name: 'withdrawal')

customer1 = Customer.last
Account.create!(customer_id: customer1.id, opened_date: Time.now, balance: 2500.0, meta_name: 'deposit')

