class FemaIpaws
	include HTTParty
	base_uri 'https://apps.fema.gov/IPAWSOPEN_EAS_SERVICE/rest'
	format :xml
	default_params 'pin' => 'MWEzMDEwM3AxMDM'
	SOURCE = Source.index('FEMA')

	def self.feed_update_time
		response = self.get('/update')
		Time.parse(response['feed']['updated'])
	end

	def self.new_alerts?
		feed_time = self.feed_update_time
		FemaIpawsUpdate.last_update < feed_time
	end

	def self.alert_urls
		response = self.get('/feed')
		entry = response['feed']['entry']
		if entry.present?
			entry = [entry] if !entry.kind_of?(Array)
			entry.map { |e|  e['link']['href'] }
		else
			[]
		end
	end

	def self.get_alert(url)
		response = self.get(url)
		mash = Hashie::Mash.new(response)
		mash.alert
	end

	def self.get_alerts
		alerts = []
		alert_urls.each do |url|
			alerts << get_alert(url)
		end
		alerts
	end

	def self.process(force = false)
		alerts = []
		if (new_alerts? || force)
			alerts = self.get_alerts
			self.process_alert(alerts)
		end

		# record the time of 
		FemaIpawsUpdate.set_update_time
		alerts.length
	end

	def self.process_alert(alerts)
		alerts.each do |a|
			if Alert.exists?(:identifier => a.identifier)
				# update alerts that exist find_or_create
			else
				alert = Alert.create! do |x|
					x.identifier = a.identifier
					x.sender = a.sender
					x.sent = Time.parse(a.sent)
					x.status = a.status
					x.msg_type = a.msgType
					x.source = a.source
					x.scope = a.scope
					x.restriction = a.restriction
					x.addresses = a.addresses
					x.code = a.code if a.code
					x.note = a.note
					x.references = a.references
					x.incidents = a.incidents
				end

				# get and save the short_url
				alert.set_short_url

				# Alert - Info
				self.process_info(alert, a)

				# create AlertZips
				zips = alert.zips
				tzs = TwitterZip.where(zip: zips)
				tzs.each {|tz| tz.alert_zips.create(:alert_id => alert.id)}

				# create ZipMessages
				#alert.create_zip_messages(SOURCE)

				# enqueue ZipMessages
				#alert.enqueue_zip_messages(SOURCE)

			end # if Alert.exists?
		end # alerts.each
	end

	def self.process_info(alert, a)
		infos = a.info.instance_of?(Array) ? a.info : [a.info].compact
		infos.each do |i|
			i = Hashie::Mash.new(i)
			info = alert.infos.create! do |x|
				x.language = i.language
				x.category = i.category
				x.event = i.event
				x.response_type = i.responseType if i.responseType
				x.urgency = i.urgency
				x.severity = i.severity
				x.certainty = i.certainty
				x.audience = i.audience
				x.effective = Time.parse(i.effective) if i.effective
				x.onset = Time.parse(i.onset) if i.onset
				x.expires = Time.parse(i.expires) if i.expires
				x.sender_name = i.senderName
				x.headline = i.headline
				x.description = i.description
				x.instruction = i.instruction
				x.web = i.web
				x.contact = i.contact
			end

			# Alert - Info - EventCode
			self.process_event_code(info, i)

			# Alert - Info - Parmeter
			self.process_parameter(info, i)

			# Alert - Info - Resource
			self.process_resource(info, i)

			# Alert - Info - Area
			self.process_area(info, i)
		end # infos.each
	end

	def self.process_event_code(info, i)
		event_codes = i.eventCode.instance_of?(Array) ? i.eventCode : [i.eventCode].compact
		event_codes.each do |ev|
			ev = Hashie::Mash.new(ev)
			event_code = info.event_codes.create! do |x|
				x.value_name = ev.valueName
				x.value = ev.value
			end
		end
	end

	def self.process_parameter(info, i)
		parameters = i.parameter.instance_of?(Array) ? i.parameter : [i.parameter].compact
		parameters.each do |p|
			p = Hashie::Mash.new(p)
			parameter = info.parameters.create! do |x|
				x.value_name = p.valueName
				x.value = p.value
			end
		end
	end

	def self.process_resource(info, i)
		resources = i.resource.instance_of?(Array) ? i.resource : [i.resource].compact
		resources.each do |r|
			r = Hashie::Mash.new(r)
			resource = info.resources.create! do |x|
				x.resource_desc = r.resourceDesc
				x.mime_type = r.mimeType
				x.size = r.size
				x.uri = r.uri
				x.deref_uri = r.derefUri
				x.digest = r.digest
			end
		end # resources.each
	end

	def self.process_area(info, i)
		areas = i.area.instance_of?(Array) ? i.area : [i.area].compact
		areas.each do |ar|
			ar = Hashie::Mash.new(ar)
			area = info.areas.create! do |x|
				x.area_desc = ar.areaDesc
				x.altitude = ar.altitude
				x.ceiling = ar.ceiling
			end

			# Alert - Info - Area - Polygon
			self.process_polygon(area, ar)

			# Alert - Info - Area - Circle
			self.process_circle(area, ar)

			# Alert - Info - Area - Geocode
			self.process_geocode(area, ar)
		end # area.each		
	end

	def self.process_polygon(area, ar)
		polygons = ar.polygon.instance_of?(Array) ? ar.polygon : [ar.polygon].compact
		polygons.each do |p|
			polygon_model = area.polygons.create! do |x|
				x.polygon = p
			end
		end
	end

	def self.process_circle(area, ar)
		circles = ar.circle.instance_of?(Array) ? ar.circle : [ar.circle].compact
		circles.each do |c|
			circle_model = area.circles.create! do |x|
				x.circle = c
			end
		end
	end

	def self.process_geocode(area, ar)
		geocodes = ar.geocode.instance_of?(Array) ? ar.geocode : [ar.geocode].compact
		geocodes.each do |g|
			g = Hashie::Mash.new(g)
			geocode = area.geocodes.create! do |x|
				x.value_name = g.valueName
				x.value = g.value
			end
		end
	end

end
