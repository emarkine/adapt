require 'rake'

# Rake::Task['db:model:load'].invoke('currency')

Country.destroy_all
US = Country.create( name: 'United States', code: 'US' )
US.save!
NL = Country.create( name: 'Netherlands', code: 'NL' )
NL.save!

Currency.destroy_all
USD = Currency.create( name: 'United States Dollar', code: 'USD', sign: '$', country: US)
USD.save!
EUR = Currency.create( name: 'Euro', code: 'EUR', sign: '€', country: NL )
EUR.save!

User.destroy_all
USER_TEST = User.create({ id: 1, name: 'test', currency: EUR, country: NL,
                   mobile: '0612345678', email: 'test@marketram.com',
                   password: 'password', password_confirmation: 'password' } )
USER_TEST.save!
USER_ADMIN = User.create({ id: 2, name: 'admin', currency: EUR, country: NL,
                           mobile: '0612345678', email: 'admin@marketram.com',
                           password: '123456', password_confirmation: '123456' } )
USER_ADMIN.save!
USER_EUGENE = User.create({ id: 3, name: 'Eugene Markin', currency: USD, country: NL,
                     mobile: '0628736786', email: 'eugene@markine.nl',
                     password: '1q2w3e4r5t', password_confirmation: '1q2w3e4r5t' } )
USER_EUGENE.save!
