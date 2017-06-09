require './app/controllers/application_controller'
task send_message: :environment do
  User.find(1).send_message(User.find(2), 'Title', 'Subject').conversation
end
