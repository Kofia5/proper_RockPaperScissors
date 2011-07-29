# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

asd =  User.create(:email => 'asd@asd.com', :username => 'asd', :password => 'asdasd', :password_confirmation => 'asdasd')

qwe = User.create(:email => 'zxc@zxc.org', :username => 'zxc', :password => 'zxczxc', :password_confirmation => 'zxczxc')

ai = User.create(:email => 'AI@AI.net', :username => 'theAI', :password => 'qweqwe', :password_confirmation => 'qweqwe')

Stats.create([{:user => qwe}, {:user => ai}, {:user => asd}])

