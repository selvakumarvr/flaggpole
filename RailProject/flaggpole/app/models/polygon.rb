class Polygon < ActiveRecord::Base
  belongs_to :area

  def zips
    # TODO: find zips in polygon
    # http://jakescruggs.blogspot.com/2009/07/point-inside-polygon-in-ruby.html
    # http://www.daniel-azuma.com/blog/archives/256
    # if using PostGIS http://postgis.refractions.net/docs/ST_Contains.html
    # could simplify to reactangular bounding box and check min and max
    []
  end
end
