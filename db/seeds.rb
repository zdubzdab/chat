5.times do |n|
  name  = "user#{n+1}"
  email = "user#{n+1}@gmail.com"
  password  = 'password'
  User.create_with(name: name,
                   password: password).find_or_create_by(email: email)
end

User.create_with(name: 'admin', password: 'password')
    .find_or_create_by(email:'admin@gmail.com')
    .add_role(:admin)

User.last(5).each do |u|
  3.times do |n|
    User.first.send_message(u, "Text#{n}", "subject#{n}")
  end
end
