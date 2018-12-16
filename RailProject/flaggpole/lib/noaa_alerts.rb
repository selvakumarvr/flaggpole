class NoaaAlerts
	SOURCE = Source.index('NOAA')

	def self.new_alerts?
		true
	end

	def self.get_alerts
		Noaa::Client.new('us', 15.minutes.ago).alerts
	end

	def self.process(force = false)
		alerts = []
		if (new_alerts? || force)
			alerts = self.get_alerts
			self.process_alert(alerts)
		end

		# record the time of last check
		#FemaIpawsUpdate.set_update_time
		alerts.length
	end

	def self.process_alert(alerts)
		alerts.each do |a|
			if Alert.exists?(:identifier => a.identifier)
				# update alerts that exist find_or_create
			else
				# detect repeats within previous hour
				repeat = Info.where(headline: a.headline).where('created_at > ?', 1.hour.ago).exists?
				next if repeat

				alert = Alert.create! do |x|
					x.identifier = a.identifier
					x.sender = a.sender
					x.sent = a.sent_at
					x.status = a.status
					x.msg_type = a.msg_type
					#x.source = a.source
					x.scope = a.scope
					#x.restriction = a.restriction
					#x.addresses = a.addresses
					#x.code = a.code if a.code
					x.note = a.note
					#x.references = a.references
					#x.incidents = a.incidents
				end

				# get and save the short_url
				alert.set_short_url

				# Alert - Info
				self.process_info(alert, a)

				# create AlertZips
				zips = alert.zips
				tzs = TwitterZip.where(zip: zips)
				tzs.each {|tz| tz.alert_zips.create(:alert_id => alert.id)}

				# only tweet and push severe immediate alerts
				immediate_severe = (a.severity == 'Severe') && (a.urgency == 'Immediate')

				if (immediate_severe)
					# create ZipMessages
					alert.create_zip_messages(SOURCE)

					# enqueue ZipMessages
					alert.enqueue_zip_messages(SOURCE)

					# enqueue APNs
					alert.enqueue_apns
				end

			end # if Alert.exists?
		end # alerts.each
	end

	def self.process_info(alert, a)
		info = alert.infos.create! do |x|
			#x.language = i.language
			x.category = a.category
			x.event = a.event
			#x.response_type = i.responseType if i.responseType
			x.urgency = a.urgency
			x.severity = a.severity
			x.certainty = a.certainty
			#x.audience = i.audience
			x.effective = a.effective_at
			#x.onset = Time.parse(i.onset) if i.onset
			x.expires = a.expires_at
			x.sender_name = a.sender_name
			x.headline = a.headline
			x.description = a.description
			x.instruction = a.instruction
			#x.web = i.web
			#x.contact = i.contact
		end

		# Alert - Info - EventCode
		#self.process_event_code(info, i)

		# Alert - Info - Parmeter
		#self.process_parameter(info, i)

		# Alert - Info - Resource
		#self.process_resource(info, i)

		# Alert - Info - Area
		self.process_area(info, a)
	end

	def self.process_area(info, a)
		area = info.areas.create! do |x|
			x.area_desc = a.area_desc
			#x.altitude = ar.altitude
			#x.ceiling = ar.ceiling
		end

		# Alert - Info - Area - Polygon
		#self.process_polygon(area, ar)

		# Alert - Info - Area - Circle
		#self.process_circle(area, ar)

		# Alert - Info - Area - Geocode
		self.process_geocode(area, a)
	end

	def self.process_geocode(area, a)
		geocodes = a.geocodes
		geocodes.each do |g|
			value_name = g.fetch('valueName')
			geocode = area.geocodes.create! do |x|
				# rename FIPS6 values to SAME
				x.value_name = value_name == 'FIPS6' ? 'SAME' : value_name
				x.value = g.fetch('value')
			end
		end
	end

end
