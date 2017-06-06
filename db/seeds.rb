5.times do |n|
  name  = "user#{n+1}"
  email = "user#{n+1}@gmail.com"
  password  = "password"
  User.create_with(name: name,
                   password: password).find_or_create_by(email: email)
end
