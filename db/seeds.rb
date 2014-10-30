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

standard_arr = [[1,'VIII'], [2,'IX'], [3,'X'], [4,'XI'], [5,'XII']]

standard_arr.each do |id, class_no|
  Standard.find_or_create_by_class_no(id: id, class_no: class_no)
end

division_arr = ['A','B','C','D','E']

division_arr.each do |division|
  Division.find_or_create_by_division(division)
end

standard_division_relationship_arr  = [[1,1],[1,2],[1,3],[2,1],[2,2],[3,1],[3,2],[3,3],[3,4],[4,1],[4,2],[4,3],[4,4],[4,5],[5,1],[5,2]]
standard_division_relationship_arr.each do |standard_id, division_id|
  StandardDivision.find_or_create_by_standard_id_and_division_id(standard_id: standard_id, division_id: division_id)
end

rules_arr = ['User vote on question', 'User vote on answer', 'User can ask question', 'User can comment', 'User report abuse', 'User can answer']
 rules_arr.each do |rule|
  Rule.find_or_create_by_description(rule)
 end

 badge_arr = ['Train', 'Doctor', 'Artist', 'Tester', 'Reviewer', 'Scholar', 'Helper']
 point_val = 20
 badge_arr.each do |badge|
  Badge.find_or_create_by_name_and_points_and_default(name: badge, points: point_val, default: false)
  point_val = point_val + 30
end

action_arr = [['Create Question',2], ['Create Answer',5], ['Question is voted up',5], ['Answer is voted up',10], ['Question is voted down',-2], ['Answer is voted down',-5], ['Answer is accepted',15], ['Question is disabled',-15]]
action_arr.each do |x,y|
  Point.find_or_create_by_score_and_action(score: y, action:"#{x}")
end
