class FemaIpawsUpdate < ActiveRecord::Base
  attr_accessible :update_time

  def self.set_update_time(t = nil)
    t ||= Time.now
    fiu = self.first
    fiu.update_attributes(:update_time => t)
  end

  def self.last_update
    self.first.update_time
  end
end
