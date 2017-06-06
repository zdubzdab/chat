5.times do |n|
  name  = "user#{n+1}"
  email = "user#{n+1}@gmail.com"
  password  = "password"
  User.create_with(name: name,
                   password: password).find_or_create_by(email: email)
end


# [:admin, :user].each do |role|
#   Role.find_or_create_by(name: role)
# end
# Role.find_or_create_by(name: :admin)

User.create_with(name: 'admin', password: 'password')
    .find_or_create_by(email:'admin@gmail.com')
    .add_role(:admin)
