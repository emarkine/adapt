# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create({ name: 'Test', surname: 'User',
                   mobile: '0612345678', email: 'test@marketram.com',
                   password: 'password', password_confirmation: 'password' } )
user.save!


user = User.create({ name: 'Eugene', surname: 'Markine',
                     mobile: '0628736786', email: 'eugene@markine.nl',
                     password: 'password', password_confirmation: 'password' } )
user.save!

