class Geocode < ActiveRecord::Base
  belongs_to :area

  def SAME?
    value_name == "SAME"
  end

  def UGC?
    value_name == "UGC"
  end

  def same
    value if SAME?
  end

  def ugc
    value if UGC?
  end

  def zips
    zips = []
    zips << TwitterZip.select(:zip).where(:same => same).map(&:zip) if SAME?
    #zips << TwitterZip.select(:zip).where(???).map(&:zip) if UGC?
    zips.flatten.uniq
  end

end
