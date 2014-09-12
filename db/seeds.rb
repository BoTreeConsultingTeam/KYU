# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def find_or_create_admin(admin_attrs)
	email = admin_attrs[:email]
	admin = Administrator.find_by_email(email)

	if admin.nil?
		admin = Administrator.create(admin_attrs)
		puts "Created admin having email #{email}"
	else 
		puts "Admin having  email #{email} already exists, thus not created"	
	end
	admin	
end	

admin_user = find_or_create_admin({email: 'admin@kyu.com', password: 'password'})
require "#{Rails.root}/db/gioco/db.rb"