module APN
	def self.push(opts = {})
		n = Rapns::Apns::Notification.new
    n.app = opts[:app]
    n.device_token = opts[:token]
    n.alert = opts[:message]
    n.attributes_for_device = opts[:attributes]
    n.save!
	end
end
