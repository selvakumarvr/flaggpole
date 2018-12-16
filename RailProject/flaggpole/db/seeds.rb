require 'csv'

['Eric', 'Mike', 'Aaron W.', 'Aaron D.'].each do |name|
  User.find_or_create_by_name(name)
end

eric = User.find_by_name 'Eric';
#Place.find_or_create_by_name(:name => '50023', :lat => 41.733, :lng => -93.632, :user_id => eric)
#Place.find_or_create_by_name(:name => '50021', :lat => 41.715, :lng => -93.571, :user_id => eric)
Place.find_or_create_by_name(:name => 'Ankeny', :lat => 41.721, :lng => -93.600, :user_id => eric)

# Create place for each zip using data from http://zips.sourceforge.net/
# Could also use fastercsv
zips = CSV.readlines(RAILS_ROOT + '/db/fixtures/zipcode.csv')
zips.shift # ignore header row
zips.each do |zip|
  #Place.find_or_create_by_name(:name => zip[0], :lat => zip[3], :lng => zip[4], :user_id => eric)
  Place.create!(:name => zip[0], :lat => zip[3], :lng => zip[4], :user_id => eric)
end