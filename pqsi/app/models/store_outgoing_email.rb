class StoreOutgoingEmail
  def self.delivering_email(message)
    case message.to.class
    when Array
      @to = message.to.join(', ')
    when String
      @to = message.to
    else
      @to = message.to.inspect
    end

    case message.from.class
    when Array
      @from = message.from.join(', ')
    when String
      @from = message.from
    else
      @from = message.from.inspect
    end

    Email.create(
      :to => @to,
      :from => @from,
      :subject => message.subject,
      :body => message.body.encoded
    )
    
    if Rails.env.development?
      message.subject = "#{message.to} #{message.subject}"
      message.to = "mr@webdesigncompany.net"
    end
  end
end