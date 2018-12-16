require "soap/wsdlDriver"
wsdl = "http://dev1.clearancejobs.com:9100/messagingManager?wsdl"
endpoint = "http://dev1.clearancejobs.com:9100/messagingManager"
ns = "http://messagingManager.services.flaggpole.com/"
#driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver 

begin
   driver = SOAP::RPC::Driver.new(endpoint, ns)
  # driver.generate_explicit_type = true
   driver.wiredump_dev = STDOUT if $DEBUG
   #driver.add_method('messageEvent', 'in')
   #puts driver.messageEvent({:event_type => 'newPost', :postID => 1})
   driver.add_method('messageEvent','in')
   driver.messageEvent(:eventType => 'newPost', :postID => 1)
rescue => err
   puts err.message
end

#lists = driver.selectLists('','')

