class FwixItem
  NAMES = %w(title source link published_at)
  attr_accessor *NAMES
  attr_reader :source_id, :uid, :message, :datetime

  def initialize(item)
    NAMES.each do |var_name|
      self.instance_variable_set("@#{var_name}", item[var_name])
    end
    @source_id = Source.index('Fwix')
    @uid = item['uuid']
    
    # time of news (timestamp) or event (end_date)
    @datetime = Time.parse(published_at)
    
    # shorten the url
    url_to_shorten = link
    @short_url = url_to_shorten.blank? ? '' : ShortUrl.shorten(url_to_shorten).short_url
    
    # shorten title if more than 140 characters
    @message = self.get_message
    excess = @message.length - 140
    if excess > 0
      title.slice!(-excess,excess)
      @message = self.get_message
    end
    
  end
  
  def get_message
    "#{title} #{@short_url}"
  end
  
  def new_item?(zip)
    !ZipMessage.exists?(:uid => @uid, :zip => zip)
  end
  
end

