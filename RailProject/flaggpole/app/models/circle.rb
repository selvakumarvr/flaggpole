class Circle < ActiveRecord::Base
  belongs_to :area

  def center
    center = center_radius.first
    center.split(',')
  end

  def radius
    radius_in_km = center_radius.second
    Geocoder::Calculations.to_miles radius_in_km.to_i
  end

  def zips
    TwitterZip.near(self.center, radius).map(&:zip)
  end

  private

  def center_radius
    self.circle.split(' ')
  end
end
