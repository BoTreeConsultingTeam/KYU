def create_or_update_by_alias(class_name, row)
  instance  = class_name.find_by_role_alias(row[:role_alias])
  if instance.blank?
    class_name.create!(row)
    puts "#{row[:name]}  added."
  else
    instance.update_attributes(row)
    puts "#{row[:name]} updated."
  end
  instance
end

# Roles
roles = [ { name: 'Operator', role_alias: Role::OPERATOR },
          { name: 'Administrator', role_alias: Role::ADMINISTRATOR },
          { name: 'Teacher', role_alias: Role::TEACHER },
          { name: 'Student', role_alias: Role::STUDENT } ]

puts '------------Seeding Roles------------'
roles.each { |role| create_or_update_by_alias(Role, role)}
puts '-------------------------------------'