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

standard_arr = ['VIII','IX','X', 'XI', 'XII']

standard_arr.each do |standard|
  Standard.create(class_no: standard)
end

rules_arr = ['User vote on question', 'User vote on answer', 'User can ask question', 'User can comment', 'User report abuse', 'User can answer']
 rules_arr.each do |rule|
  Rule.create(description: rule)
 end 

 badge_arr = ['Train', 'Doctor', 'Artist', 'Tester', 'Reviewer', 'Scholar', 'Helper']
 point_val = 20
 badge_arr.each do |badge|
  Badge.create(name: badge, points: point_val, default: false)
  point_val = point_val + 30
end

action_arr = [['Create Question',2], ['Create Answer',5], ['Question is voted up',5], ['Answer is voted up',10], ['Question is voted down',-2], ['Answer is voted down',-5], ['Answer is accepted',15], ['Question is disabled',-15]]
action_arr.each do |x,y|
  Point.create(score: y, action:"#{x}")
end
