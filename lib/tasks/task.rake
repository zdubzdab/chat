task send_new_message: :environment do
  User.first.send_message(User.last, 'Title', 'Subject').conversation
end
