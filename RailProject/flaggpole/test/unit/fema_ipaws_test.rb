require 'test_helper'

class FemaIpawsTest < ActiveSupport::TestCase

	def setup
    base_uri = 'https://tdl.apps.fema.gov/IPAWSOPEN_EAS_SERVICE/rest'
    stub_request(:get, base_uri + '/update?pin=MWEzMDEwM3AxMDM').to_return(File.new(Rails.root + 'test/fixtures/webmock/fema_update.txt'))
    stub_request(:get, base_uri + '/feed?pin=MWEzMDEwM3AxMDM').to_return(File.new(Rails.root + 'test/fixtures/webmock/fema_feed.txt'))
    regex = Regexp.new(Regexp.escape(base_uri + '/eas/') + '\d+' + Regexp.escape('?pin=MWEzMDEwM3AxMDM'))
    stub_request(:get, regex).to_return(lambda { |request|
      id = File.basename(request.uri.path.to_s)
      File.new(Rails.root + "test/fixtures/webmock/fema_#{id}.txt")
    })
	end

  test "no new updates when date is in past" do
    fiu = FemaIpawsUpdate.first
    fiu.update_attributes(update_time: Time.local(2012, 4, 11, 12, 0, 0))
    assert_equal false, FemaIpaws.new_alerts?
  end

  test "new updates when date is more recent" do
		fiu = FemaIpawsUpdate.first
    fiu.update_attributes(update_time: Time.local(2012, 4, 9, 12, 0, 0))
  	assert FemaIpaws.new_alerts?
  end

  test "feed is an array" do
    assert_instance_of Array, FemaIpaws.alert_urls
  end

  test "feed entry has valid link attribute" do
    entry = FemaIpaws.alert_urls.first
    assert_match /\/rest\/eas\/\d+/, entry
  end
end
