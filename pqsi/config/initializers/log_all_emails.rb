class MailObserver
  def self.delivered_email(message)
    puts message.class
    puts message['to']
    puts message['from']
    puts message['subject']
    puts message['body']
    Email.log_email(message)
  end
end

ActionMailer::Base.register_observer(MailObserver)