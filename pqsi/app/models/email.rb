class Email < ActiveRecord::Base
  def self.log_email(this_mail)
    # logger.this_email.class
    # logger.this_email.inspect
    
    # Email.create( :to       => this_mail.to.to_s, 
    #               :from     => this_mail.from.to_s, 
    #               :subject  => this_mail.subject, 
    #               :body     => this_mail.body)
  end
end
