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

def find_or_create_class(class_atrs)
	standard_no = class_atrs[:class_no]

	standard = Standard.find(class_no: standard_no)

	if standard.nil?
		standard = Standard.create(class_atrs)
		puts "Created admin having email #{email}"
	else 
		puts "Admin having  email #{email} already exists, thus not created"	
	end
	standard
end	

admin_user = find_or_create_admin({email: 'admin@kyu.com', password: 'password'})

standard_arr = ['VIII','IX','X', 'XI', 'XII']

standard_arr.each do |standard|
  find_or_create_class(standard)
end

