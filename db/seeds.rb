require 'rake'

# Rake::Task['db:model:load'].invoke('country')
# Rake::Task['db:model:load'].invoke('currency')

US = Country.create( name: 'United States', code: 'US' )
US.save!
USD = Currency.create( name: 'United States Dollar', code: 'USD', sign: '$', country: US, state: 'market' )
USD.save!
NL = Country.create( name: 'Netherlands', code: 'NL' )
NL.save!
EUR = Currency.create( name: 'Euro', code: 'EUR', sign: '€', country: NL, state: 'market' )
EUR.save!

USER_TEST = User.create({ name: 'Test', surname: 'User', currency: EUR,
                   mobile: '0612345678', email: 'test@marketram.com',
                   password: 'password', password_confirmation: 'password' } )
USER_TEST.save!

USER_ADMIN = User.create({ name: 'Admin', surname: 'User', currency: EUR,
                           mobile: '0612345678', email: 'admin@marketram.com',
                           password: '123456', password_confirmation: '123456' } )
USER_ADMIN.save!

USER_EUGENE = User.create({ name: 'Eugene', surname: 'Markine', currency: USD,
                     mobile: '0628736786', email: 'eugene@markine.nl',
                     password: 'secret123', password_confirmation: 'secret123' } )
USER_EUGENE.save!
