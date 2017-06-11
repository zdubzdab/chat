module FeatureHelper
  def log_in(user, options = {})
    visit sessions_new_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Submit'
  end

  def send_message(receiver, subject, message)
    visit new_conversation_path
    select "#{receiver.name}",           from: 'conversation[recipients][]'
    fill_in 'Subject',                   with: subject
    fill_in 'conversation[body]',        with: message
    click_on 'Send Message'
  end
end
