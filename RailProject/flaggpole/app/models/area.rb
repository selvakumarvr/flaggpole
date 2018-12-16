class Area < ActiveRecord::Base
  belongs_to :info
  has_many :polygons, :dependent => :destroy
  has_many :circles, :dependent => :destroy
  has_many :geocodes, :dependent => :destroy

  validates_presence_of :area_desc

  def zips
    zips = []
    zips << self.polygons.map(&:zips)
    zips << self.circles.map(&:zips)
    zips << self.geocodes.map(&:zips)
    zips.flatten.uniq
  end

  def same_codes
    self.geocodes.select{|g| g.value_name == 'SAME'}.map(&:value);
  end
end
