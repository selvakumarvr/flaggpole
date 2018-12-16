class GrouponZip < ActiveRecord::Base
  belongs_to :groupon_division
  belongs_to :twitter_zip
  RADIUS = 25
  
  def self.populate
    divisions = GrouponDivision.all
    division_count = {}
    divisions.each do |gd|
      print gd.name
      division_count[gd.name] = 0
      division_loc = [gd.latitude, gd.longitude]
      zips = TwitterZip.registered.can_login.near(division_loc, RADIUS)
      zips.each do |tz|
        unless exists?(:groupon_division_id => gd, :twitter_zip_id => tz)
          gd.groupon_zips.create(:twitter_zip => tz)
          #puts "create #{gd.division_id} #{tz.zip} #{tz.distance}"
        end
        division_count[gd.name] += 1
        #gd.twitter_zips.find_or_create_by_twitter_zip(:twitter_zip => tz)
      end
      puts ' ' + division_count[gd.name].to_s
    end
    total = division_count.values.inject{|sum,item| sum + item}
    puts "Total: #{total}"
    division_count
  end
  
end
