class NotificationsMailer < ActionMailer::Base
  default :from => "feedback@twitzip.com"
  default :to => "ryan@twitzip.com"

  def new_message(message)
    @message = message
    mail(:subject => "[twitzip.com] Contact Form")
  end

end
