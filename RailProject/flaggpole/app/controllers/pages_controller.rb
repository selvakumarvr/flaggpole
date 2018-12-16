class PagesController < ApplicationController
	def get_started
		@message = Message.new
	end

	def create_message
		@message = Message.new(params[:message])

		if @message.valid?
			NotificationsMailer.new_message(@message).deliver
			redirect_to(root_path, :notice => "Message was successfully sent.")
		else
			flash.now.alert = "Please fill in all the fields."
			render :get_started
		end
	end
end
