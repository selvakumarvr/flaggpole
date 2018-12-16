require 'rubygems'
require 'mechanize'

def change_password(username, old_password, new_password)
  login_url = 'http://twitter.com/login'
  password_url = 'http://twitter.com/account/password'
  agent = WWW::Mechanize.new
  
  # login to Twitter
  page = agent.get(login_url)
  login_form = page.forms[1]
  login_form.field_with(:name => 'session[username_or_email]').value = username
  login_form.field_with(:name => 'session[password]').value = old_password
  page = agent.submit(login_form)
  
  # change password
  page = agent.get(password_url)
  form = page.form_with(:name => 'f')
  form.field_with(:name => 'current_password').value = old_password
  form.field_with(:name => 'user_password').value = new_password
  form.field_with(:name => 'user_password_confirmation').value = new_password
  page = agent.submit(form)

  #  check for success
  puts (page.body =~ /Your password has been changed/) ? 'success' : 'fail'
end

