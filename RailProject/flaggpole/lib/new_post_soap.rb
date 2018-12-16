# wsdl: http://dev.flaggpole.com:9100/messagingManager?wsdl
MESSAGING_SERVICE_ENDPOINT = {
  :uri => 'http://dev1.clearancejobs.com:9100/messagingManager',
  :version => 1
}

require 'rubygems'
require 'pp'
require 'handsoap'

class MessagingService < Handsoap::Service
#  MessagingService.logger = $stdout
  endpoint MESSAGING_SERVICE_ENDPOINT
  on_create_document do |doc|
    doc.alias 'mes', ns
  end

  def new_post(postID)
    response = invoke("mes:messageEvent", :soap_action => :none) do |m|
      m.add 'eventType', 'newPost'
      m.add 'postID', postID
    end
    response.document.xpath('//ns:out/success/text()', ns).to_boolean
  end

  def ns
    { 'ns' => 'http://messagingManager.services.flaggpole.com/' }
  end
end

postID = ARGV.shift or raise
result = MessagingService.new_post(postID)
pp result
